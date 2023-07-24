extends Camera3D
var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		pass
		#var dir = (global_position - player.global_position).normalized()
		#global_rotation = dir
