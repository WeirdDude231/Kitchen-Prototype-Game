extends Node3D
#Ok so basically grab the mesh, use it to set the albedo to whatever the enemy node has.
var SelectedColor = Color(0.0, 0.0, 0.0, 1.0)

#The blood splatter knows where it is, and where it isn't. It will simply go where the player isn't.

func _ready() -> void:
	var mesh = $BloodPart
	var c = mesh.get_active_material(0)
	
	c.albedo_color = SelectedColor #This will be set by what was assigned to the enemy through creation code.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direc: Vector3 = global_position - Global.target.global_position #Find the player position, and not go where the player is at.
	position.y -= 2.5*delta
	global_position += direc * 2.5*delta


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Ground"):
		print("Destruction")
		var blood = Global.GroundBlood.instantiate()
		blood.global_position = global_position
		blood.position.y += 0.01
		blood.TheColorOfBloodWhenItFallsFromTheEnemy = SelectedColor
		get_tree().current_scene.add_child(blood)
		queue_free()
