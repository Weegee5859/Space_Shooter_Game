extends CharacterBody3D
@export var damage: float = 5
@export var speed: float = 17
@export var deleteOnContact: bool = true
@export var isEnemyBullet: bool = false
@export var spawnOffsetz: float = 0
var direction: Vector3
@onready var delete_self_timer = $DeleteSelfTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	direction.z = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = direction * speed
	move_and_slide()


func _on_delete_self_timer_timeout():
	queue_free()


func _on_area_3d_area_entered(area):
	var enemy = area.get_parent()
	if deleteOnContact:
		queue_free()
