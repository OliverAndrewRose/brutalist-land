extends Node
class_name LookTowards

var look_toward: Vector3;


func look_towards(direction: Vector3):
	look_toward = direction;
	pass
	
func _process(delta):
	var target_transform = owner.get_global_transform().looking_at(look_toward, Vector3.UP);
	owner.global_transform = owner.get_global_transform().interpolate_with(target_transform, delta*4);
	#owner.look_at(look_toward, Vector3.UP);
	pass
