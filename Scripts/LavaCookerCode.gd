extends Node3D

var CookLimit = 5 #How many times this grill can be used, once it's expired the grill will self destruct ;)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y < -0.03:
		position.y += 7.5*delta
