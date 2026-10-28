extends Node3D

#These ranges offset how far away the enemy will spawn from the point.
@export var MinRangeX: float ##Minimum spawning range on the X coordinate.
@export var MaxRangeX: float ##Maximum spawning range on the X coordinate.
@export var MinRangeZ: float ##Minimum spawning range on the Z coordinate.
@export var MaxRangeZ: float ##Maximum spawning range on the Z coordinate.

@onready var SpawnTimer = $SpawnTimer
@onready var FlameTimer = $FlameTimer

var RandNumber = randi_range(1, 3) #Random number picker, depending on the number will spawn a food enemy.
#Dish spawns are a little different, there has to be enough of a certain food for a certain dish to spawn in.
#Such as, if there's meat, a meat plate can spawn if picked. Otherwise if there's no meat, a meat plate won't spawn.

var XRange = randf_range(MinRangeX, MaxRangeX)
var ZRange = randf_range(MinRangeZ, MaxRangeZ)

var SpawnSpot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnTimer.start(randf_range(3.5, 7.4)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("Enemy").size() < Global.EnemyLimit && Global.Stage == 1:
		var enemy = Global.Enemy.instantiate()
		match RandNumber:
			1:
				enemy.img = "Meat"
				enemy.FoodType = "Meat"
				enemy.EnemySpeed = 4.8
			2:
				enemy.img = "Rat"
				enemy.FoodType = "Rat"
				enemy.EnemySpeed = 9.3
			3:
				enemy.img = "Poison"
				enemy.FoodType = "Poison"
				enemy.EnemySpeed = 3.1
		enemy.global_position = global_position
		enemy.position.x += XRange
		enemy.position.z += ZRange
		enemy.Summoned = true
		get_tree().current_scene.add_child(enemy)
		RandNumber = randi_range(1, 3)
	SpawnTimer.wait_time = randf_range(3.5, 7.4)
