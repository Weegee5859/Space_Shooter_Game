extends CharacterBody3D
@export var shotgun_power_up: bool = false
@export var size_power_up: bool = false
@export var bullet_speed_power_up: bool = false



func _ready():
	pass
	
func _physics_process(delta):
	rotation.y += 0.05

func _on_area_3d_area_entered(area):
	if shotgun_power_up:
		Global.player.shotgun = true
	if bullet_speed_power_up:
		Global.player.current_bullet_speed += 50
	if size_power_up:
		Global.player.current_bullet_size += 0.7
		
	queue_free()


func _on_area_3d_body_entered(body):
	pass
