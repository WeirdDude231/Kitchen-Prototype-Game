extends MeshInstance3D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("Shrink")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Shrink":
		queue_free()
