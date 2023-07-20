extends CharacterBody3D
var speed: float = 25
var direction: Vector3
@onready var delete_self_timer = $DeleteSelfTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	direction.z = -1
	#direction = Vector3(0,0,-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = direction * speed
	move_and_slide()


func _on_delete_self_timer_timeout():
	queue_free()
