extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_RECOVERY_TIME = 0.08
const INVINCIBILITY_DURATION = 1.0
const DEFAULT_SPRITE_SCALE = Vector2(2.0, 2.0)
const SPRITE_CENTER_OFFSET_X = 20.5

const IDLE_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/idle.png")
const RUN_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/run.png")
const JUMP_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/jump.png")
const FALL_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/fall.png")
const ATTACK_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/attacks.png")
const DAMAGED_TEXTURE = preload("res://sprites/Buck Borris/Buck Borris/damaged.png")

var facing := 1
var is_attacking := false
var current_attack_animation := "attack_stand"
var attack_timer := 0.0
var jump_count := 0
var health := 5
var max_health := 5
var is_invincible := false
var invincibility_timer := 0.0
var is_crouching := false
var damage_animation_timer := 0.0
var current_animation := ""
var animation_frame := 0
var animation_timer := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	add_to_group("player")
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)
	sprite.scale = DEFAULT_SPRITE_SCALE
	_play_animation("idle")


func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_count = 0

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Invincibility frames
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0.0:
			is_invincible = false
			modulate.a = 1.0

	if damage_animation_timer > 0.0:
		damage_animation_timer -= delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count == 1:
			velocity.y = JUMP_VELOCITY
			jump_count = 2
			_spin()

	# Handle crouch
	is_crouching = Input.is_action_pressed("crouch") and is_on_floor()
	if is_crouching:
		sprite.scale = Vector2(DEFAULT_SPRITE_SCALE.x, DEFAULT_SPRITE_SCALE.y * 0.75)
		sprite.position.y = 6
		collision_shape.shape.height = 20
		collision_shape.position.y = 10
	else:
		sprite.scale = DEFAULT_SPRITE_SCALE
		sprite.position.y = 0
		collision_shape.shape.height = 40
		collision_shape.position.y = 0

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		current_attack_animation = _get_attack_animation()
		attack_timer = _get_attack_duration(current_attack_animation)
		$Hitbox.position.x = facing * 25
		$Hitbox.position.y = 10 if is_crouching else 0
		$Hitbox/CollisionShape2D.set_deferred("disabled", false)
		$Hitbox/Sprite2D.visible = true

	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			is_attacking = false
			$Hitbox/CollisionShape2D.set_deferred("disabled", true)
			$Hitbox/Sprite2D.visible = false

	# Handle movement
	var direction := Input.get_axis("left", "right")
	if direction:
		facing = int(direction)
		sprite.flip_h = facing == -1
		_update_sprite_offset()
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_update_animation(delta, direction)


func take_damage(amount: int, knockback_dir: int) -> void:
	if is_invincible:
		return
	health -= amount
	is_invincible = true
	invincibility_timer = INVINCIBILITY_DURATION
	velocity = Vector2(knockback_dir * 200, -150)

	# Pisca o sprite durante a invencibilidade
	damage_animation_timer = 0.25
	_play_animation("damaged", true)
	var tween := create_tween().set_loops(5)
	tween.tween_property(self, "modulate:a", 0.2, 0.1)
	tween.tween_property(self, "modulate:a", 1.0, 0.1)

	if health <= 0:
		queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not is_attacking:
		return
	if area.is_in_group("enemy_hurtbox"):
		var enemy := area.get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage(1, facing)


func _spin() -> void:
	var tween := create_tween()
	tween.tween_property(sprite, "rotation_degrees", 360.0, 0.4).from(0.0)
	tween.tween_callback(func(): sprite.rotation_degrees = 0.0)


func _update_animation(delta: float, direction: float) -> void:
	if damage_animation_timer > 0.0:
		_play_animation("damaged")
	elif is_attacking:
		_play_animation(current_attack_animation)
	elif not is_on_floor():
		if velocity.y < 0.0:
			_play_animation("jump")
		else:
			_play_animation("fall")
	elif is_crouching:
		_play_animation("idle")
	elif abs(direction) > 0.0:
		_play_animation("run")
	else:
		_play_animation("idle")

	_advance_animation(delta)


func _play_animation(animation_name: String, force_restart := false) -> void:
	if current_animation == animation_name and not force_restart:
		return

	current_animation = animation_name
	animation_frame = 0
	animation_timer = 0.0

	var data := _get_animation_data(animation_name)
	sprite.texture = data["texture"]
	sprite.hframes = 1
	sprite.vframes = data["total_frames"]
	sprite.frame = data["start_frame"]
	_update_sprite_offset()


func _advance_animation(delta: float) -> void:
	var data := _get_animation_data(current_animation)
	if data["frames"] <= 1:
		return

	animation_timer += delta
	if animation_timer < 1.0 / data["fps"]:
		return

	animation_timer = 0.0
	animation_frame += 1
	if animation_frame >= data["frames"]:
		animation_frame = 0 if data["loop"] else data["frames"] - 1

	sprite.frame = data["start_frame"] + animation_frame


func _get_animation_data(animation_name: String) -> Dictionary:
	match animation_name:
		"run":
			return _animation_data(RUN_TEXTURE, 4, 10.0, true)
		"jump":
			return _animation_data(JUMP_TEXTURE, 1, 1.0, false)
		"fall":
			return _animation_data(FALL_TEXTURE, 1, 1.0, false)
		"attack_stand":
			return _animation_data(ATTACK_TEXTURE, 4, 16.0, false, 0, 12)
		"attack_crouch":
			return _animation_data(ATTACK_TEXTURE, 5, 16.0, false, 4, 12)
		"attack_air":
			return _animation_data(ATTACK_TEXTURE, 4, 16.0, false, 8, 12)
		"damaged":
			return _animation_data(DAMAGED_TEXTURE, 2, 8.0, false)
		_:
			return _animation_data(IDLE_TEXTURE, 5, 8.0, true)


func _update_sprite_offset() -> void:
	sprite.offset.x = -SPRITE_CENTER_OFFSET_X if sprite.flip_h else SPRITE_CENTER_OFFSET_X


func _get_attack_animation() -> String:
	if not is_on_floor():
		return "attack_air"
	if is_crouching:
		return "attack_crouch"
	return "attack_stand"


func _animation_data(
	texture: Texture2D,
	frames: int,
	fps: float,
	loop: bool,
	start_frame := 0,
	total_frames := 0
) -> Dictionary:
	return {
		"texture": texture,
		"frames": frames,
		"fps": fps,
		"loop": loop,
		"start_frame": start_frame,
		"total_frames": frames if total_frames == 0 else total_frames,
	}


func _get_attack_duration(animation_name: String) -> float:
	var data := _get_animation_data(animation_name)
	return float(data["frames"]) / float(data["fps"]) + ATTACK_RECOVERY_TIME
