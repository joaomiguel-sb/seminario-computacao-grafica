extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_DURATION = 0.3

var facing := 1
var is_attacking := false
var attack_timer := 0.0
var jump_count := 0


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_count = 0

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count == 1:
			velocity.y = JUMP_VELOCITY
			jump_count = 2
			_spin()

	# Handle crouch
	if Input.is_action_pressed("crouch") and is_on_floor():
		$Sprite2D.scale.y = 0.5
		$Sprite2D.position.y = 16
		$CollisionShape2D.shape.height = 20
		$CollisionShape2D.position.y = 10

	if not Input.is_action_pressed("crouch"):
		$Sprite2D.scale.y = 1
		$Sprite2D.position.y = 0
		$CollisionShape2D.shape.height = 40
		$CollisionShape2D.position.y = 0

	# Handle attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		$Hitbox.position.x = facing * 25
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
		$Sprite2D.flip_h = facing == -1
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _spin() -> void:
	var tween := create_tween()
	tween.tween_property($Sprite2D, "rotation_degrees", 360.0, 0.4).from(0.0)
	tween.tween_callback(func(): $Sprite2D.rotation_degrees = 0.0)
