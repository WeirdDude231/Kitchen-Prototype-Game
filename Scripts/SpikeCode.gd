extends Node3D

@export var Proximity: bool = false ##Engage spike when player gets too close
@export var Timed: bool = false ##Engage spike after some time
@export var SpikeTime: float = 0.0 ##How long until the spike engages
@export var Active: bool = false ##If the spike is active or not

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Proximity == false && Timed == false: print("Error, spike cannot engage. All flags are set to false.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Proximity == true:
		var distance = global_position.distance_to(get_tree().get_first_node_in_group("Player").global_position)
		print(distance)
