extends CharacterBody3D

@export var EnemyHP: int = 1
@export var EnemySpeed: float = 1.0
@export var EnemyDamage: int = 1
@export var EnemyAttSpd: float = 1.0
@export var FoodType: String = "null" ##For enemies that are food, by default they are not food
@export var AnimSpd: float = 3.0 ##How fast to play the animation
@export var img: String ##Which sprite to use, this needs to be equal to the animation in the animated sprite 3D.

@onready var nav = $NavigationAgent3D
@onready var KnockTime = $EndKnock
@onready var sprite = $AnimatedSprite3D
@onready var ray = $RayCast3D

var player

var distance
var attTimer = EnemyAttSpd

var Knocked = false #Knockback, if true get knocked back from the player for a short time
var KnockDir = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	sprite.play(img)

func _physics_process(delta: float) -> void:
	if Knocked == true:
		velocity += KnockDir * Global.KnockPower
		
	distance = global_position.distance_to(player.global_position)
	#print(distance)
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y -= 2
	var nextLoc = nav.get_next_path_position()
	var currentLoc = global_transform.origin
	var newVelo = (nextLoc - currentLoc).normalized() * EnemySpeed
	
	nav.set_velocity(newVelo)
	
	if distance <= 2.25:
		if attTimer <= 0:
			attTimer = EnemyAttSpd
			player.PlayerHP -= 1
			#player.DamageEffect.play("Pain")
			print("Player hit")
		else:
			attTimer -= 1*delta
	
	

func _targetPos(target):
	nav.target_position = target

func _on_area_3d_area_entered(area: Area3D) -> void:
	if FoodType == "null":
		if area.is_in_group("Bullet"):
			print("Enemy has been hit")
			EnemyHP -= (1+Global.DamageModifier)*Global.DamageMultiplier
			area.queue_free()
	else:
		if area.is_in_group("Melee"):
			print("Enemy has been hit by melee")
			EnemyHP -= (1+Global.DamageModifier)*Global.DamageMultiplier
			Knocked = true
			KnockDir = Global.target.global_position.direction_to(global_position)
			KnockTime.start()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


func _on_end_knock_timeout() -> void:
	Knocked = false
