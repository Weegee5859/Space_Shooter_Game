extends Node3D
@export var offset: int = 3
@onready var spawn_cooldown_timer = $SpawnCooldownTimer
var wavesCompleted: bool
var enemies: Dictionary = {
	"grunt": preload("res://Enemies/enemy.tscn"),
	"meteor": preload("res://Bullets/enemy_meteor.tscn")
}

@export var waves_of_enemies: Dictionary = {
	"Wave 1": [{"enemy": enemies["grunt"], "cooldown": 1.2,"quantity": 7},{"enemy": [enemies["grunt"],enemies["meteor"]], "cooldown": 2,"quantity": 10}]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	startWaves()

func startWaves():
	if wavesCompleted == true: return
	for wave in waves_of_enemies:
		print(waves_of_enemies[wave])
		spawnEnemiesOfWave(waves_of_enemies[wave])
	print("WAVES COMPLETED")
	wavesCompleted = true
		

func spawnEnemiesOfWave(wave):
	for enemy in wave:
		print(enemy)
		for i in enemy["quantity"]:
			if not spawn_cooldown_timer.is_stopped():
				await spawn_cooldown_timer.timeout
			spawnEnemy(enemy["enemy"],enemy["cooldown"])

func spawnEnemy(enemy,cooldown):
	var instanced_enemy = enemy
	if enemy is Array:
		instanced_enemy = enemy[randi_range(0,enemy.size()-1)]
	# Instantiate Enemy
	instanced_enemy = instanced_enemy.instantiate()
	instanced_enemy.position = position
	instanced_enemy.position.x += randi_range(offset*-1,offset)
	instanced_enemy.position.y += randi_range(offset*-1,offset)
	get_tree().get_root().add_child(instanced_enemy)
	print("SPAWNED IN " + str(enemy))
	if enemy is Array:
		print("its packed")
	
	spawn_cooldown_timer.start()
