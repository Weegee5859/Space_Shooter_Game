extends Node3D
@export var offset_x: float = 3
@export var offset_y: float = 2
@onready var spawn_cooldown_timer = $SpawnCooldownTimer

@onready var decrease_spawn_timer = $decreaseSpawnTimer
@onready var increase_quantity_timer = $increaseQuantityTimer
@onready var add_new_enemy_timer = $addNewEnemyTimer
@onready var increase_enemy_spawn_rate_timer = $increaseEnemySpawnRateTimer


@onready var EnemySpawnRate: float = 5
@onready var VarietyOfEnemies: float = 1


var wavesCompleted: bool
var enemies: Dictionary = {
	"grunt": preload("res://Enemies/enemy.tscn"),
	"speedster": preload("res://Enemies/speedy_enemy.tscn"),
	"meteor": preload("res://Bullets/enemy_meteor.tscn"),
	"shotgun_pwrup": preload("res://PowerUps/shotgun_power_up.tscn"),
	"bullet_speed_pwrup": preload("res://PowerUps/bullet_speed_power_up.tscn"),
	"bullet_size_pwrup": preload("res://PowerUps/size_power_up.tscn")
}

@export var waves_of_enemies: Dictionary = {
	"Wave 1": [{"enemy": enemies["grunt"], "cooldown": 1.2,"quantity": 2},{"enemy": [enemies["shotgun_pwrup"],enemies["bullet_speed_pwrup"],enemies["bullet_size_pwrup"]], "cooldown": 0.1,"quantity": 20},{"enemy": [enemies["grunt"],enemies["meteor"]], "cooldown": 2,"quantity": 10}]
}
@export var infinite_wave: Array = [
	{"enemy": enemies["grunt"], "cooldown": 1.2,"quantity": 2, "quantityMax": 6, "secondsToSpawn": 12, "secondsToSpawnMin": 3},
	{"enemy": enemies["speedster"], "cooldown": 1.2,"quantity": 2, "quantityMax": 6, "secondsToSpawn": 12, "secondsToSpawnMin": 3},
	{"enemy": enemies["meteor"], "cooldown": 1.2,"quantity": 2, "quantityMax": 4, "secondsToSpawn": 12, "secondsToSpawnMin": 3},
	{"enemy": [enemies["shotgun_pwrup"],enemies["bullet_speed_pwrup"],enemies["bullet_size_pwrup"]], "cooldown": 1.2, "quantity": 1, "quantityMax": 2, "secondsToSpawn": 12, "secondsToSpawnMin": 3}
]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_new_enemy_timer.wait_time = 60*1
	increase_quantity_timer.wait_time = 60*3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_cooldown_timer.is_stopped():
		startInfiniteWaves()
	#startWaves()
	
func startInfiniteWaves():
	print(len(infinite_wave))
	if not spawn_cooldown_timer.is_stopped(): return
	var amountOfEnemies: int = randi_range(1,2)
	for i in amountOfEnemies:
		var random_enemy = infinite_wave[randi_range(0,VarietyOfEnemies)]
		for z in random_enemy["quantity"]:
			spawn_cooldown_timer.wait_time = EnemySpawnRate
			spawnEnemy(random_enemy["enemy"],EnemySpawnRate)
	


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
	instanced_enemy.position.x += randi_range(offset_x*-1,offset_x)
	instanced_enemy.position.y += randi_range(offset_y*-1,offset_y)
	get_tree().get_root().add_child(instanced_enemy)
	print("SPAWNED IN " + str(enemy))
	if enemy is Array:
		print("its packed")
	
	spawn_cooldown_timer.start()


func _on_add_new_enemy_timer_timeout():
	if VarietyOfEnemies<len(infinite_wave)-1:
		VarietyOfEnemies += 1


func _on_increase_quantity_timer_timeout():
	for enemy in infinite_wave:
		if enemy["quantity"] < enemy["quantityMax"]:
			enemy["quantity"] = enemy["quantity"]+1
