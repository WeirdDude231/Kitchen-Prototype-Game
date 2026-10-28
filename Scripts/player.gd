extends CharacterBody3D


var SPEED = 10.0
const JUMP_VELOCITY = 4.5
var direction

@export var PlayerHP = 4
@export var sens = 0.003

const bob_freq = 2.0
const bob_amp = 0.06
var t_bob = 0.0

var MeleeCooldown = 0.0 #How long to wait between melee swings

var Invincible = false #When true, no damage

#⠀⠀⠀⢘⠀⡂⢠⠆⠀⡰⠀⡀⢀⣠⣶⣦⣶⣶⣶⣶⣾⣿⣿⡿⢀⠈⢐⠈⠀⠀
#⠀⠀⠀⡃⠀⡀⣞⡇⢰⠃⣼⣇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣰⣻⡀⢸⠀⠀⠀
#⠀⠀⢐⢀⠀⣛⣽⣇⠘⢸⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⠟⢡⣾⣿⢿⡇⠀⡃⠀⠀
#⠀⠀⢐⠀⠀⢳⣿⡯⡞⣾⣿⣿⣿⣿⣿⣿⢿⣿⠟⢁⣴⣿⣿⣿⡜⢷⠀⢘⠄⠀
#⠀⠀⠂⡂⠸⡆⠙⠛⡵⣿⣿⣿⣿⣿⡿⠤⠛⣠⣴⣿⣿⠿⣟⣟⠟⢿⡆⢳⠀⠀
#⠀⠀⠸⠁⠀⡾⠁⠀⠀⠀⠀⠉⠉⠉⠈⣠⡌⢁⠄⡛⠡⠉⠍⠙⢳⢾⠁⢸⠀⠀
#⠀⠀⢈⠀⢀⠌⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣷⡎⠙⢬⣳⣪⡯⢜⣷⢸⠂⡈⠄⠀
#⠀⠀⠐⡀⠀⢣⠀⠀⠀⠀⠀⠀⠀⣴⣿⣾⣷⢿⢻⣅⣌⡯⢛⣿⣿⡞⠠⡁⠂⠀
#⠀⠀⠀⠄⠀⢉⡀⠀⠀⢀⡠⠤⠼⣇⣳⣿⣿⣟⡜⣿⣿⣿⣿⣿⣿⡇⠸⠡⠀⠀
#⠀⠀⡀⠅⠀⠃⢀⡀⣿⡹⠗⢀⠛⠥⣺⣿⣿⡝⢹⣸⣿⣿⣿⣿⡏⠠⠰⠈⠐⠀
#⠠⠈⠀⠄⣀⠀⠀⠸⠻⠦⠀⠀⠀⠀⠀⠉⠐⠀⠘⠻⢹⣿⡿⠃⠀⡀⠕⣈⠡⡄
#⠀⠀⣴⡀⣬⠁⠀⠀⡁⠂⠀⣀⣀⠔⠌⠤⣀⡀⠀⠀⡈⢸⠪⠀⠀⡌⠤⠈⡀⣠
#⠀⠀⣿⣿⣾⡇⠀⠀⠀⣴⢫⣾⠃⠠⢰⣶⣴⠶⣿⣦⠀⠀⠀⢄⣂⠀⠀⠰⠀⠙
#⠀⠀⠉⠛⠛⠀⢀⣴⣿⢗⡟⠡⣄⣀⡀⠀⢀⣤⠞⡅⠀⠁⠀⡾⠀⠀⠠⡗⠀⢀
#⠀⠀⠀⠀⠀⣴⡿⢋⠔⠃⠀⠀⠍⠙⠉⠈⠑⠁⠂⠀⠀⠀⡡⡁⣠⡼⣸⠅⠀⠘
#⠀⠀⠀⣼⠛⢡⠔⠁⠐⣆⠀⠀⠀⠀⠀⠀⠀⠀⠁⢀⡔⡞⢛⣿⡿⠃⠏⠀⠀⢠
#⠀⠀⠀⠈⠗⠀⠀⠀⠀⠘⣷⣀⢀⣀⣀⠀⡀⢀⣌⡧⠂⠀⡞⠛⡟⠀⠀⠀⡠⠜
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠓⠈⠙⠙⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⡂⠠⠤⢶


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var DamageIndct = $AnimationPlayer
@onready var DamagePart = $TextureRect
@onready var BloodSplat = $BloodEffect #Consistent names? Never heard of it.
@onready var BloodUI = $BloodSplatter

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DamagePart.modulate.a = 0.0
	BloodSplat.rotation.z = 90.0

func _unhandled_input(event: InputEvent) -> void:
	#This moves the camera with the mouse, and only the camera.
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(60))
		
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	 #Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	t_bob += delta * velocity.length() * float(is_on_floor()) #Jiggle the player
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("attack") && MeleeCooldown <= 0.0:
		var melee = Global.PlayerMeleeBox.instantiate()
		melee.global_position = global_position
		melee.player = self
		get_tree().current_scene.add_child(melee)
		MeleeCooldown = 0.65
	
	if MeleeCooldown > 0.0: MeleeCooldown -= 1*delta
		
	#Handle blood effects on the UI.
	if PlayerHP >= 4:
		BloodUI.visible = false
	else:
		BloodUI.visible = true
		match PlayerHP:
			3:
				BloodUI.frame = 1
			2:
				BloodUI.frame = 2
			1:
				BloodUI.frame = 3
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time*bob_freq) * bob_amp
	pos.x = cos(time*bob_freq/2) * bob_amp
	return pos


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Hurtbox"):
		PlayerHP -= 1
		DamageIndct.play("DmgIndication")
		BloodSplat.emitting = true
