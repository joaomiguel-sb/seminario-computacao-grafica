extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle crouch
	if Input.is_action_pressed("crouch") and is_on_floor():
		$Sprite2D.scale.y = 0.5
		$Sprite2D.position.y = 16
		$CollisionShape2D.shape.height = 20
		
	if not Input.is_action_pressed("crouch"):
		$Sprite2D.scale.y = 1
		$Sprite2D.position.y = 0
		$CollisionShape2D.shape.height = 40

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if direction == -1:
			$Sprite2D.flip_h = true 
		if direction == 1:
			$Sprite2D.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
