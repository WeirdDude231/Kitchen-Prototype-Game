extends Node

#Vibecoded? Nah coded on frustration and music, I'm tired af as of writing this.

#Get stuff ready
var StartTimer = false
@onready var RoundTimer = $RoundStartTimer
#Player stuff
var PlayerPoint

#Loading
#Attacks and traps
var PlayerMeleeBox = load("res://Objects/melee_zone.tscn")
var SpikeStrip = load("res://Attacks/spike_strip.tscn")
var LavaCircle = load("res://Attacks/lava_circle.tscn")

#Enemy assets
var Enemy = load("res://Objects/enemy.tscn")
var MeatEnemy = load("res://Sprites/LivingSteak.png")
var RatEnemy = load("res://Sprites/DevilRat.png")
var PsnEnemy = load("res://Sprites/PoisonSludge.png")
var MeatDish = load("res://Sprites/PlateEnemyMeat.png")
var RatDish = load("res://Sprites/EvilRatPlate.png")
var PsnDish = load("res://Sprites/PoisonSludgePlate.png") #I shortened some of these names so the lines kind of match lengths.

#Particles
var ChunkyParticles = load("res://Effects/chunk_particles.tscn") #Chunk particles from dead enemies
var FallingBlood = load("res://Effects/blood_particle.tscn") #Blood orbs that fall from hit enemies
var GroundBlood = load("res://Effects/blood_splat.tscn") #2D blood sprites that form on the ground after the blood part.
var SummonFlame = load("res://Effects/summoning_flame.tscn")
var Burst = load("res://Effects/burst_to_flames.tscn")

#Stages
var AttackID = 0 #Which attack to execute, each attack has an ID and will be set off by a timer.
#Once this timer goes off the attack will execute right away, there is one timer.
var AttackTimer = 5.0 #How long to execute the chosen attack.
static var Stage = 0 #Starting stage, nothing happens during stage 0 and only a cutscene. This will lead into everything else.
#Card effects are not at all affected by the stage unless it's stage 0 

#Stage 0: Cutscene/Card picking/Break time
#Stage 1: Summon enemies: This includes cards that chase the player or are active on the field.
#Stage 2: Spawn traps and hazards: This also includes cards from the previous stage.
#Stage 3: Boss fight

#Why am I doing a stage 0? I have no f##kin clue.

#Cards: This is the fun stuff that happens during the game, so like, idk, random stuff.
#These cards below are just random effects
var TrailOfLava = false #Lava Trail Card: Lava constantly trails behind the player, forcing the player
#to keep constantly moving. Make sure to start this not on the player so they don't take immediate damage,
#because players like doing no-hit runs and such. (I think)
var TheReaper = false #A big floaty skele will follow the player around sometimes. Unlike the trail
#of lava, the player can attack this entity, and the entity will have a slow attack speed.
var Jumpy = false #Force the player to jump around cause lmao. This will also be in random intervals as to not
#make it predictable.
var SpontaneousLaser = false #Spawn a random laser that will go in a random direction. Note: This won't be
#right on the player, just near the player.
var Bombs = false #Random bombs will spawn around the map
#These cards below are modifyers (is that how I spell it?) and affects many things.
#Such as player speed, damage, as well as enemy spawn rates, amounts, damage, etc. Anything could be changed here.
var EnemyHPMod = 0.0 #How much health to add to the enemy
var EnemySpdMod = 0.0 #How much speed to add to the enemy

#Traps and hazards
#Now I would use a bool to use multiple traps/hazards at once, but I don't wanna make multiple timers or whatever.
#Besides, I feel like it could get really, really chaotic with so much going on in a small space.
var TrapID = 0 #What kind of trap to use

#Other stuff
var target
var DamageModifier = 0 #How much damage to add
var DamageMultiplier = 1.0 #How much damage to multiply
var KnockPower = 1.75
var EnemyLimit = 10 #How many enemies can be in the room at once.

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
	if Stage == 2:
		if AttackTimer <= 0.0:
			match TrapID:
				0:
					var ZPos = -20 #Where to place a spike strip on the Z coordinate
					for i in 10:
						var strip = SpikeStrip.instantiate()
						strip.position.x = 0.0
						strip.position.y = 0.015
						strip.position.z = ZPos
						get_tree().current_scene.add_child(strip)
						ZPos += 5
			AttackTimer = 5.0
		else:
			AttackTimer -= 1*delta
	
	#Spawn in the card entities
	if get_tree().get_nodes_in_group("LavaTrail").size() < 1 && TrailOfLava == true && Stage == 1:
		var trail = Enemy.instantiate()
		trail.LavaTrail = true
		trail.EnemySpeed = 6.9 #Haha funi number
		trail.global_position = Vector3(18.0, 0.0, -18.0)
		add_child(trail)
	
	#Round manager
	#if RoundTimer.is_stopped() && Stage == 0:
		#pass
		


func _on_round_start_timer_timeout() -> void:
	Stage += 1
