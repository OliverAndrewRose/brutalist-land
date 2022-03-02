extends RayCast


func _process(_delta):
	_process_door_open();


func _process_door_open():
	if get_collider() != null and get_collider().has_method("toggle_door_state"):
		if not get_collider().door_is_open:
			get_collider().force_door_open();
	pass
