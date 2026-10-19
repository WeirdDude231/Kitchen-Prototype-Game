extends Node3D

@onready var SpawnTimer = $SpawnTimer

var RandNumber = randi_range(1, 3) #Random number picker, depending on the number will spawn a food enemy.
#Dish spawns are a little different, there has to be enough of a certain food for a certain dish to spawn in.
#Such as, if there's meat, a meat plate can spawn if picked. Otherwise if there's no meat, a meat plate won't spawn.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var enemy = Global.Enemy.instantiate()
	match RandNumber:
		1:
			enemy.img = "Meat"
			enemy.EnemySpeed = 2.5
		2:
			enemy.img = "Rat"
			enemy.EnemySpeed = 5.8
		3:
			enemy.img = "Poison"
			enemy.EnemySpeed = 1.5
	enemy.global_position = global_position
	get_tree().current_scene.add_child(enemy)
	RandNumber = randi_range(1, 3)
