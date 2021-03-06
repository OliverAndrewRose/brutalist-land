extends Node
class_name LookTowards

# A helper class allowing the NPC to look towards a certain position.

onready var look_toward: Vector3 = owner.transform.xform(Vector3.FORWARD);

func look_towards(direction: Vector3):
	look_toward = Vector3(direction.x, owner.get_global_transform().origin.y, direction.z);
	pass
	
func _process(delta):
	#Ensures that the NPC doesn't rotate in the x or z axis.
	look_toward = Vector3(look_toward.x, owner.get_global_transform().origin.y, look_toward.z);
	
	var target_transform = owner.get_global_transform().looking_at(look_toward, Vector3.UP);
	owner.global_transform = owner.get_global_transform().interpolate_with(target_transform, delta*4);
	pass
