extends Area3D

var time = 0.1 #Destroy object after some time.
var player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time > 0.0: time -= 1*delta
	else: queue_free()
	
	if player != null:
		rotation.y = player.head.rotation.y
		global_position = player.global_position
