extends Node3D

@onready var Multimesh = $Spikes
@onready var Strip = $Strip
@onready var Box = $Hurtbox

var time = 0.75

func _process(delta: float) -> void:
	if time > 0.0:
		time -= 1*delta
	else:
		Multimesh.visible = true
		Strip.visible = false
		Box.position.y = 3.65

func _on_destroy_strip_timeout() -> void:
	queue_free()
