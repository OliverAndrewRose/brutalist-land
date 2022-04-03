extends RayCast

export(float) var door_close_delay: float = 5.0;


func _process(_delta):
	_process_door_open();


func _process_door_open():
	if get_collider() != null and get_collider().has_method("toggle_door_state"):
		if not get_collider().door_is_open:
			get_collider().force_door_open(); # Open the door
			set_door_to_close(get_collider() as DoorOpenCloser) # Set the door to close.
	pass


# Set the door to close after [door_close_delay] amount of seconds.
func set_door_to_close(door: DoorOpenCloser):
	var door_close_timer: Timer = Timer.new();
	add_child(door_close_timer)
	door_close_timer.connect("timeout", self,"_close_door", [door, door_close_timer])
	door_close_timer.start(door_close_delay);

# Close the door, and delete the timer.
func _close_door(door: DoorOpenCloser, timer: Timer):
	door.force_door_close();
	timer.stop();
	timer.queue_free();
