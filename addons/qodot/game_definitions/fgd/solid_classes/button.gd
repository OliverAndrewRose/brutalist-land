extends Spatial

signal trigger()
signal pressed()
signal released()

export(Dictionary) var properties setget set_properties

var pressed = false
var base_translation = Vector3.ZERO
var axis := Vector3.DOWN
var speed := 8.0
var depth := 0.8
var release_delay := 0.0
var trigger_signal_delay :=  0.0
var press_signal_delay :=  0.0
var release_signal_delay :=  0.0
var attach_to;

var overlaps := 0
var _initial_attached_offset = Vector3.ZERO;
var _attached_object: Spatial

func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()

func update_properties() -> void:
	
	
	if 'axis' in properties:
		axis = properties.axis.normalized()

	if 'speed' in properties:
		speed = properties.speed

	if 'depth' in properties:
		depth = properties.depth;

	if 'release_delay' in properties:
		release_delay = properties.release_delay

	if 'trigger_signal_delay' in properties:
		trigger_signal_delay = properties.trigger_signal_delay

	if 'press_signal_delay' in properties:
		press_signal_delay = properties.press_signal_delay

	if 'release_signal_delay' in properties:
		release_signal_delay = properties.release_signal_delay
		
	if 'attach_to' in properties:
		attach_to = properties.attach_to

func _init() -> void:
	connect("body_shape_entered", self, "body_shape_entered")
	connect("body_shape_exited", self, "body_shape_exited")


func _attach_to_object():
	
	if attach_to != null:
		_attached_object = get_tree().get_root().get_node("Root/QodotHelper").get_nodes_by_targetname(attach_to)[0];
		_initial_attached_offset = get_transform().origin - _attached_object.get_transform().origin;
		pass


func _enter_tree() -> void:
	base_translation = translation


func _ready():
	_attach_to_object()


func _process(delta: float) -> void:
	#var target_position = base_translation + (axis * (depth if pressed else 0.0))
	#translation = translation.linear_interpolate(target_position, speed * delta)
	_process_attached_movement();


func _process_attached_movement():
	if attach_to != null:
		transform.origin = _attached_object.get_transform().origin + _initial_attached_offset;
	pass


func body_shape_entered(body_id: int, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody:
		return

	if overlaps == 0:
		press()

	overlaps += 1

func body_shape_exited(body_id: int, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody:
		return

	overlaps -= 1
	if overlaps == 0:
		if release_delay == 0:
			release()
		elif release_delay > 0:
			yield(get_tree().create_timer(release_delay), "timeout")
			release()


func receive_interaction(user: Spatial):
	emit_trigger();


func press() -> void:
	if pressed:
		return

	pressed = true

	emit_trigger()
	emit_pressed()

func emit_trigger() -> void:
	yield(get_tree().create_timer(trigger_signal_delay), "timeout")
	emit_signal("trigger")

func emit_pressed() -> void:
	yield(get_tree().create_timer(press_signal_delay), "timeout")
	emit_signal("pressed")

func release() -> void:
	if not pressed:
		return

	pressed = false

	yield(get_tree().create_timer(release_signal_delay), "timeout")
	emit_signal("released")
