extends Spatial
class_name HarpoonRope

var start_body: Spatial;
var end_body: Spatial;

func _process(delta):
	
	if not start_body or not end_body:
		return;
		
	if not weakref(start_body).get_ref() or not weakref(end_body).get_ref():
		self.queue_free();
		return;
	
	_set_position();
	_set_rotation();
	_set_scale();
	
	pass


func _set_position():
	global_transform.origin = (end_body.global_transform.origin + start_body.global_transform.origin) / 2
	pass
	
	
func _set_rotation():
	look_at(end_body.global_transform.origin, Vector3.UP);
	pass
	
	
func _set_scale():
	scale.z = (start_body.global_transform.origin - end_body.global_transform.origin).length();
	pass
