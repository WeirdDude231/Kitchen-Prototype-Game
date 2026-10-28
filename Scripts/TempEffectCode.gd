extends CPUParticles3D

func _ready() -> void:
	emitting = true

func _on_destroy_timer_timeout() -> void:
	queue_free()
