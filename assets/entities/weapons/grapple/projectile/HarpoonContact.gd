extends RigidBody

var _connected_body: Spatial;
var _rotation_offset: Vector3;
var _position_offset: Vector3;

func _on_Harpoon_body_entered(body):
	
	if _connected_body == null:
		print("Harpoon contact")
		_connected_body = body;
		_position_offset = self.global_transform.origin - body.global_transform.origin;
		_rotation_offset = self.rotation - body.rotation;
		pass


func _physics_process(delta):
	
	if not _connected_body:
		return;
	
	if not weakref(_connected_body).get_ref():
		_clear_connected_body();
		return;
	
	_process_transform();
	pass


func _clear_connected_body():
	_connected_body = null;
	pass


func _process_transform():
	self.global_transform.origin = _connected_body.global_transform.origin + _position_offset;
	self.rotation = _connected_body.rotation + _rotation_offset;
	pass


func is_hooked() -> bool:
	if _connected_body != null and weakref(_connected_body).get_ref():
		return true;
	else:
		return false;
