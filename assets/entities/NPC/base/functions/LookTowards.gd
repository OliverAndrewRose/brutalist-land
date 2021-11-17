extends Node
class_name LookTowards

var look_toward: Vector3 = Vector3.FORWARD;


func look_towards(direction: Vector3):
	look_toward = Vector3(direction.x, owner.get_global_transform().origin.y, direction.z);
	pass
	
func _process(delta):
	var target_transform = owner.get_global_transform().looking_at(look_toward, Vector3.UP);
	owner.global_transform = owner.get_global_transform().interpolate_with(target_transform, delta*4);
	#owner.look_at(look_toward, Vector3.UP);
	pass
