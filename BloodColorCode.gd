extends Node3D

var TheColorOfBloodWhenItFallsFromTheEnemy = Color(0.0, 0.0, 0.0, 1.0) #Set the color, this will be set by BloodSplatterCode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh = $Splat
	var c = mesh.get_active_material(0) #Get the silly material :3
	c.albedo_color = TheColorOfBloodWhenItFallsFromTheEnemy
	
	rotation.y = randf_range(0.0, 359.9)
	scale = Vector3(randf_range(0.80, 1.95), 1.0, randf_range(0.80, 1.95))

func _on_destroy_timer_timeout() -> void:
	queue_free()
