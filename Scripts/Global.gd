extends Node

#Loading
#Attacks and traps
var PlayerMeleeBox = load("res://Objects/melee_zone.tscn")
var SpikeStrip = load("res://Attacks/spike_strip.tscn")

#Enemy assets
var Enemy = load("res://Objects/enemy.tscn")
var MeatEnemy = load("res://Sprites/LivingSteak.png")
var RatEnemy = load("res://Sprites/DevilRat.png")
var PsnEnemy = load("res://Sprites/PoisonSludge.png")
var MeatDish = load("res://Sprites/PlateEnemyMeat.png")
var RatDish = load("res://Sprites/EvilRatPlate.png")
var PsnDish = load("res://Sprites/PoisonSludgePlate.png")


#Stages
var AttackID = 0 #Which attack to execute, each attack has an ID and will be set off by a timer.
#Once this timer goes off the attack will execute right away, there is one timer.
var AttackTimer = 5.0 #How long to execute the chosen attack.
var Stage = 1 #Starting stage, nothing happens during this time and only a cutscene. This will lead into everything else.

#Other stuff
var target
var DamageModifier = 0 #How much damage to add
var DamageMultiplier = 1.0 #How much damage to multiply
var KnockPower = 1.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Manage pathfinding
	if target != null:
		get_tree().call_group("Enemy", "_targetPos", target.global_position)
		#print(target)
	else:
		print("Searching for player, current room: " + str(get_tree().current_scene))
		target = get_tree().get_first_node_in_group("Player")
	#Manage global attacks
	if AttackTimer <= 0.0:
		match Stage:
			1:
				var ZPos = -40 #Where to place a spike strip on the Z coordinate
				for i in 10:
					var strip = SpikeStrip.instantiate()
					strip.position.x = 0.0
					strip.position.y = 0.015
					strip.position.z = ZPos
					get_tree().current_scene.add_child(strip)
					ZPos += 10
		AttackTimer = 5.0
	else:
		AttackTimer -= 1*delta
