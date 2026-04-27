extends CharacterBody2D

@export var max_health := 3
@export var speed := 80.0
@export var patrol_distance := 150.0
@export var contact_damage := 1

var health: int
var direction := 1
var start_x: float
var _knockback_timer := 0.0
var _knockback_vel := 0.0


func _ready() -> void:
	health = max_health
	start_x = global_position.x
	add_to_group("enemies")
	$Hurtbox.add_to_group("enemy_hurtbox")
	$Hurtbox.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if _knockback_timer > 0.0:
		_knockback_timer -= delta
		velocity.x = _knockback_vel
	else:
		# Vira ao atingir o limite de patrulha ou parede
		var dist := global_position.x - start_x
		if dist >= patrol_distance or is_on_wall():
			direction = -1
		elif dist <= -patrol_distance:
			direction = 1

		velocity.x = direction * speed
		$Sprite2D.flip_h = direction == -1

	move_and_slide()


func take_damage(amount: int, hit_direction: int) -> void:
	health -= amount
	_knockback_vel = hit_direction * 250
	_knockback_timer = 0.2

	# Flash vermelho
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 0.2, 0.2), 0.05)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)

	if health <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(contact_damage, direction)
