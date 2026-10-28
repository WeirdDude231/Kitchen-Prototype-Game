extends CharacterBody3D
#Notes: Keep enemy speed above 1.0, otherwise the enemy floats. Idk why, don't feel like fixing it.


@export var EnemyHP: int = 1
@export var EnemySpeed: float = 1.0
@export var EnemyDamage: int = 1
@export var EnemyAttSpd: float = 1.0
@export var FoodType: String = "null" ##For enemies that are food, by default they are not food
@export var AnimSpd: float = 3.0 ##How fast to play the animation
@export var img: String ##Which sprite to use, this needs to be equal to the animation in the animated sprite 3D.
@export var Summoned: bool = false ##Enemy plays a cool summoning animation

@export var LavaTrail: bool = false ##Lava trail, this is just for the card effect. All I'm doing here is reusing the enemy just to follow the player around.

@onready var nav = $NavigationAgent3D
@onready var KnockTime = $EndKnock
@onready var sprite = $AnimatedSprite3D

var player

var distance
var attTimer = EnemyAttSpd

var Knocked = false #Knockback, if true get knocked back from the player for a short time
var KnockDir = 0.0

func _ready() -> void:
	if LavaTrail == true:
		sprite.visible = false
		add_to_group("LavaTrail")
	
	player = get_tree().get_first_node_in_group("Player")
	sprite.play(img)
	
	if Summoned == false:
		$PillarOfFlame.queue_free()
		$CircleOfFire.queue_free()
	else:
		$Summon.play("SummonAnim")
		$CircleOfFire.emitting = true

func _physics_process(delta: float) -> void:
	position.y = 0.0
	if Knocked == true:
		velocity += KnockDir * Global.KnockPower
		
	if player != null: distance = global_position.distance_to(player.global_position)
	#print(distance)
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y -= 2
	var nextLoc = nav.get_next_path_position()
	var currentLoc = global_transform.origin
	var newVelo = (nextLoc - currentLoc).normalized() * EnemySpeed
	
	nav.set_velocity(newVelo)
	
	if LavaTrail == false:
		if distance <= 2.25:
			if attTimer <= 0:
				attTimer = EnemyAttSpd
				player.PlayerHP -= 1
				player.DamageIndct.play("DmgIndication")
				player.BloodSplat.emitting = true
				print("Player hit")
			else:
				attTimer -= 1*delta
		
		if EnemyHP <= 0:
			var particle = Global.ChunkyParticles.instantiate()
			particle.global_position = global_position
			particle.emitting = true
			particle.rotation.z = 90.0
			get_tree().current_scene.add_child(particle)
			queue_free()

func _targetPos(target):
	nav.target_position = target

func _on_area_3d_area_entered(area: Area3D) -> void:
	if LavaTrail == false:
		if FoodType == "null":
			if area.is_in_group("Bullet"):
				#print("Enemy has been hit")
				EnemyHP -= (1+Global.DamageModifier)*Global.DamageMultiplier
				area.queue_free()
		else:
			if area.is_in_group("Melee"):
				#print("Enemy has been hit by melee")
				EnemyHP -= (1+Global.DamageModifier)*Global.DamageMultiplier
				Knocked = true
				KnockDir = Global.target.global_position.direction_to(global_position)
				KnockTime.start()
		if area.is_in_group("Hurtbox"):
			var BurstEffect = Global.Burst.instantiate()
			BurstEffect.global_position = global_position
			get_tree().current_scene.add_child(BurstEffect)
			queue_free()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if Summoned == false: move_and_slide()


func _on_end_knock_timeout() -> void:
	Knocked = false


func _on_summon_animation_finished(anim_name: StringName) -> void:
	if anim_name == "SummonAnim":
		Summoned = false
		$PillarOfFlame.queue_free()


func _on_drop_lava_timer_timeout() -> void:
	if LavaTrail == true:
		var lava = Global.LavaCircle.instantiate()
		lava.global_position = global_position
		get_tree().current_scene.add_child(lava)
	else:
		$DropLavaTimer.stop()
