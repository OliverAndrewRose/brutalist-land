extends KinematicBody

export(Dictionary) var properties setget set_properties

var base_transform: Transform
var offset_transform: Transform
var target_transform: Transform
var speed := 1.0

func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()


func update_properties() -> void:
	if 'translation' in properties:
		offset_transform.origin = properties.translation

	if 'rotation' in properties:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, properties.rotation.x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, properties.rotation.y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, properties.rotation.z)

	if 'scale' in properties:
		offset_transform.basis = offset_transform.basis.scaled(properties.scale)

	if 'speed' in properties:
		speed = properties.speed

func _physics_process(delta: float) -> void:
	transform = transform.interpolate_with(target_transform, (speed * delta) * offset_transform.origin.length() / (transform.origin.distance_to(target_transform.origin) + 1))

func _init() -> void:
	base_transform = transform
	target_transform = base_transform

func use() -> void:
	play_motion()

func play_motion() -> void:
	target_transform = base_transform * offset_transform

func reverse_motion() -> void:
	target_transform = base_transform

func toggle_motion() -> void:
	print(transform.origin.distance_to(target_transform.origin));
	if is_in_motion():
		return;
	
	if(transform.origin.distance_to(base_transform.origin) < 0.1):
		play_motion();
	else:
		reverse_motion();

func is_in_motion() -> bool:
	if transform.origin.distance_to(target_transform.origin) < 0.1:
		return false;
	else:
		return true;
