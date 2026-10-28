extends Timer
#Why can't I just start this timer in the Global script? This engine is like working with a stubborn child!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.StartTimer == true:
		start()
		Global.StartTimer = false
