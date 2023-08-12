extends CharacterBody3D

@export var max_health: float = 100
var current_health: float
@export var speed: float = 5.0
const acceleration: float = 1
const deacceleration: float = 0.5
const rotation_speed: float = 1
const max_rotation: float = 35.0

@onready var camera = get_tree().get_root().get_camera_3d()
var ray_origin = Vector3()
var ray_end = Vector3()
var shoot_dir: Vector3

var direction: Vector3

@onready var shoot_cooldown_timer = $shootCooldownTimer

@onready var mesh_cursor = $meshCursor

#Power Ups
var shotgun:bool = false

var default_bullet_size: float = 0.5
var current_bullet_size: float = default_bullet_size
var max_bullet_size: float = 3

var default_bullet_speed: float = 15
var current_bullet_speed: float = default_bullet_speed
var max_bullet_speed: float = 80

var default_armor: int = 0
var current_armor: int = default_armor

@onready var cursor = $Cursor
@onready var model = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D

@onready var hit_flash = $HitFlash
@onready var hit_flash_timer = $HitFlash/Timer

	
func _ready():
	Global.player = self
	current_health = max_health

func _physics_process(delta):
	movement()
	cursorMovement()
	if Input.is_action_pressed("shoot"):
		shoot()
	handleHitFlash()
	move_and_slide()
	
func handleHitFlash():
	if hit_flash_timer.is_stopped(): return
	hit_flash.visible = true	
	
func activateHitFlash():
	hit_flash_timer.start()
	
func deactivateHitFlash():
	hit_flash.visible = false

func cursorMovement():
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	#var cusor_mouse_pos = get_viewport().get_mouse_global_position()
	
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	#ray_end.y -= 20
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersect = space_state.intersect_ray(query)
	
	if not intersect.is_empty():
		var ray_pos = intersect.position
		cursor.global_position = Vector3(camera.global_position.x + (mouse_pos.x - get_viewport().size.x/2),camera.global_position.y,-1)	
		shoot_dir = (ray_pos - global_position).normalized()
		ray_cast_3d.target_position = ray_pos
		if shoot_dir.z >=0:
			shoot_dir.z = -0.8
		
	# Cursor Position
	var cursor_pos: Vector3
	cursor_pos.x = (mouse_pos.x - get_viewport().size.x/2) / get_viewport().size.x
	cursor_pos.y = (mouse_pos.y - get_viewport().size.y/2) / get_viewport().size.y
	
	cursor.global_position.x = camera.global_position.x + (cursor_pos.x * 1)
	cursor.global_position.y = camera.global_position.y + (cursor_pos.y * 1 * -1)
	cursor.global_position.z = 0	
	#print(cursor_pos)
	#print(camera.global_position)
	
	
func instanced_bullet(object=null,offsetx=0,offsety=0,offsetz=0):
	if not object: return null
	var inst = object.instantiate()
	# set objects direction, position, and rotation
	inst.direction = shoot_dir
	inst.direction = (mesh_cursor.global_position - global_position).normalized()
	inst.position = Vector3(global_position.x+offsetx,global_position.y+offsety,global_position.z+offsetz)
	inst.speed = default_bullet_speed + current_bullet_speed
	if inst.speed>max_bullet_speed:
		inst.speed=max_bullet_speed
	inst.scale = Vector3(default_bullet_size,default_bullet_size,default_bullet_size) * current_bullet_size
	if inst.scale.x > max_bullet_size:
		inst.scale = Vector3(max_bullet_size,max_bullet_size,max_bullet_size)
	return inst
	
func shoot(my_dir=Vector3(0,0,0)):
	if not shoot_cooldown_timer.is_stopped():
		return
	
	var bullet = preload("res://Bullets/player_bullet.tscn")
	var inst = instanced_bullet(bullet)
	# add instantiated object to level
	get_tree().get_root().add_child(inst)
	
	if shotgun:
		var shotgun_bullet_1 = instanced_bullet(bullet,-0.4,0,0.3)
		var shotgun_bullet_2 = instanced_bullet(bullet,0.4,0,0.3)
		# add instantiated object to level
		get_tree().get_root().add_child(shotgun_bullet_1)
		get_tree().get_root().add_child(shotgun_bullet_2)
	
	shoot_cooldown_timer.start()

	
func movement():
	var input_dir = Vector3(0,0,0)
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	direction.x =  input_dir.x
	direction.y =  input_dir.y
	if direction:
		velocity = direction * speed
		self.rotation_degrees.x = move_toward(rotation_degrees.x, direction.y * max_rotation, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, direction.x * max_rotation * -1, rotation_speed)
	else:
		velocity = Vector3(0,0,0)
		self.rotation_degrees.x = move_toward(rotation_degrees.x, 0, rotation_speed)
		self.rotation_degrees.y = move_toward(rotation_degrees.y, 0, rotation_speed)
		self.rotation_degrees.z = move_toward(rotation_degrees.z, 0, rotation_speed)

func takeDamage(damage: float):
	current_health -= damage
	activateHitFlash()
	# Rotate player for damage
	self.rotation_degrees.z = 20
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


func _on_timer_timeout():
	deactivateHitFlash()
