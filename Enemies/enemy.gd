extends CharacterBody3D
@onready var shoot_timer = $shootTimer

@export var max_health: float = 5
var current_health: float
var left:bool = true
var roam_origin: float
var roam_speed: float = 0.4
var shoot_time: float = randf_range(1,5)

var explosion = preload("res://Particles/enemy_explosion.tscn")



func _ready():
	current_health = max_health
	switchRoamDirection()
	randomizeShootTimer()
	shoot_timer.start()

func _physics_process(delta):
	move_and_slide()
	roam()

func switchRoamDirection():
	if randi_range(1,2) == 1:
		left = false

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
	if left:
		velocity.x = roam_speed
	else:
		velocity.x = roam_speed * -1

func takeDamage(damage: float):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	var inst = explosion.instantiate()
	inst.global_position = global_position
	get_tree().get_root().add_child(inst)
	queue_free()

func _on_area_3d_area_entered(area):
	var player_bullet = area.get_parent()
	#print(player_bullet)
		
	if "damage" in player_bullet:
		takeDamage(player_bullet.damage)


func _on_shoot_timer_timeout():
	# Swap direction bool
	left = not left
	shoot()
	randomizeShootTimer()
	shoot_timer.start()
	
