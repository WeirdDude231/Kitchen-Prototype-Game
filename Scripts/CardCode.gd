extends Node3D

@onready var spr = $"Card Sprite"
@onready var anim = $AnimationPlayer

var FollowSpd = 4.0

var CardID = 0 #Which card to use, a random ID is chosen and after some time that card's effect is put into action.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("Rise")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.PlayerPoint != null:
		var playerPOS = Global.PlayerPoint.global_position
		global_position = global_position.lerp(playerPOS, delta * FollowSpd)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Rise":
		anim.play("Float")


func _on_destroy_card_timer_timeout() -> void:
	match CardID:
		0:
			Global.TrailOfLava = true
	
	Global.StartTimer = true
	queue_free()
