extends CharacterBody3D

@export var max_health: float = 100
var current_health: float
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
		# set objects direction, position, and rotation
		inst.direction = direction / 7
		inst.position = global_position
		inst.rotation = rotation
		# add instantiated object to level
		get_tree().get_root().add_child(inst)
	
func movement():
	var input_dir = Vector3(0,0,0)
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	direction.x =  input_dir.x
	direction.y =  input_dir.y
	if direction:
		velocity = direction * SPEED
		self.rotation_degrees.x = direction.y * max_rotation
		self.rotation_degrees.y = direction.x * max_rotation * -1
	else:
		velocity = Vector3(0,0,0)
		self.rotation_degrees.x = move_toward(rotation_degrees.x, 0, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, 0, rotation_speed)

func takeDamage(damage: float):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	return
	queue_free()

func _on_area_3d_area_entered(area):
	var enemy_bullet = area.get_parent()
	#print(player_bullet)
	if "damage" in enemy_bullet:
		takeDamage(enemy_bullet.damage)
