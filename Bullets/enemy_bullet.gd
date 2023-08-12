extends CharacterBody3D
class_name EnemyBullet
@export var damage: float = 5
@export var speed: float = 1
@export var bullet_speed: float = 6
@export var deleteOnContact: bool = true
@export var spawnOffsetz: float = 0
@export var rotateSelf: bool
var direction: Vector3
@onready var delete_self_timer = $DeleteSelfTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == null or direction == Vector3(0,0,0):
		print("nulllllllllllllllllllllllllllllllllll")
		direction.z = 1
		position.z += spawnOffsetz
		

func rotateBullet():
	var rotation_speed = 0.02
	if rotateSelf:
		rotation.z += rotation_speed
		rotation.y += rotation_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = direction * bullet_speed
	move_and_slide()
	rotateBullet()


func _on_delete_self_timer_timeout():
	queue_free()


func _on_area_3d_area_entered(area):
	var enemy = area.get_parent()
	if deleteOnContact:
		queue_free()
