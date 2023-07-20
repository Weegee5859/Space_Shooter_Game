extends CharacterBody3D


const SPEED = 5.0
const acceleration: float = 1
const deacceleration: float = 0.5
const rotation_speed: float = 10.0
const max_rotation: float = 35.0

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.y, input_dir.x, 0)).normalized()
	direction.y = direction.y*1
	direction.x = direction.x*-1
	if direction:
		velocity.x = move_toward(velocity.x, SPEED*direction.y, acceleration)
		velocity.y = move_toward(velocity.y, SPEED*direction.x, acceleration)
		self.rotation_degrees.x = move_toward(rotation_degrees.x, direction.x * max_rotation, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, direction.y * max_rotation * -1, rotation_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deacceleration)
		velocity.y = move_toward(velocity.y, 0, deacceleration)
		self.rotation_degrees.x = move_toward(rotation_degrees.x, 0, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, 0, rotation_speed)

	move_and_slide()
