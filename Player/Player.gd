extends CharacterBody3D


const SPEED = 5.0
const acceleration: float = 1
const deacceleration: float = 0.5
const rotation_speed: float = 20.0
const max_rotation: float = 15.0
var direction: Vector3

func _physics_process(delta):
	movement()
	shoot()
	move_and_slide()
	
func shoot():
	if Input.is_action_just_pressed("shoot"):
		# instantiate object
		var object = preload("res://Bullets/bullet.tscn")
		var inst = object.instantiate()
		# set objects direction, positio, and rotation
		inst.direction = direction / 7
		inst.position = position
		inst.rotation = rotation
		# add instantiated object to level
		get_tree().get_root().add_child(inst)
	
func movement():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	direction.x =  input_dir.x
	direction.y =  input_dir.y
	print(direction)
	#direction.y = direction.y*1
	#direction.x = direction.x*-1
	#direction.z = direction.y
	if direction:
		velocity = direction * SPEED
		self.rotation_degrees.x = direction.y * max_rotation
		self.rotation_degrees.y = direction.x * max_rotation * -1
		#self.rotation_degrees.x = move_toward(rotation_degrees.y, direction.y * max_rotation, rotation_speed)
		#self.rotation_degrees.y = move_toward(rotation_degrees.x, direction.x * max_rotation, rotation_speed)
		#self.rotation_degrees.z = move_toward(rotation_degrees.z, direction.y * max_rotation, rotation_speed)
	else:
		#velocity.x = move_toward(velocity.x, 0, deacceleration)
		#velocity.y = move_toward(velocity.y, 0, deacceleration)
		velocity = Vector3(0,0,0)
		self.rotation_degrees.x = move_toward(rotation_degrees.x, 0, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, 0, rotation_speed)
	
