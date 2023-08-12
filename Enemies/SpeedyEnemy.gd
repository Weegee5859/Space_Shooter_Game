extends CharacterBody3D
@onready var shoot_timer = $shootTimer

@export var max_health: float = 5
var current_health: float

var roam_state:bool = true

var roam_speed: float = 12
var roam_direction: Vector2
var roam_time: float = 0.3
var shoot_time: float = 2
@onready var state_timer = $state_timer

var explosion = preload("res://Particles/enemy_explosion.tscn")



func _ready():
	current_health = max_health
	randomizeDirection()
	
	roam_state = true
	state_timer.wait_time = roam_time
	state_timer.start()

func _physics_process(delta):
	if roam_state:
		roam()
	else:
		velocity = Vector3(0,0,0)
		
	move_and_slide()

func directionToPlayer():
	if Global.player:
		return (Global.player.global_position - global_position).normalized()
	return Vector3(0,0,0)
	
func shoot():
	# instantiate object
	var object = preload("res://Bullets/enemy_bullet.tscn")
	var inst = object.instantiate()
	# set objects direction, position, and rotation'
	inst.direction = directionToPlayer()
	inst.position = global_position
	#inst.position.z +=3
	inst.rotation = rotation
	# add instantiated object to level
	get_tree().get_root().add_child(inst)
	
func randomizeShootTimer():
	shoot_timer.wait_time = shoot_time
	
func roam():
	velocity.x = roam_direction.x * roam_speed
	velocity.y = roam_direction.y * roam_speed

func takeDamage(damage: float):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	var inst = explosion.instantiate()
	inst.global_position = global_position
	get_tree().get_root().add_child(inst)
	queue_free()
	
func randomizeDirection():
	roam_direction = Vector2(randi_range(-1,1),randi_range(-1,1))

func _on_area_3d_area_entered(area):
	var player_bullet = area.get_parent()
		
	if "damage" in player_bullet:
		takeDamage(player_bullet.damage)

func _on_shoot_timer_timeout():
	return

func _on_state_timer_timeout():
	randomizeDirection()
	#Going from roam state to shoot state
	if roam_state:
		state_timer.wait_time = shoot_time
		shoot()
	else:
	# Going from shooting to roaming
		state_timer.wait_time = roam_time
	# Toggle roam state
	roam_state = not roam_state
	# Reset timer
	state_timer.start()
