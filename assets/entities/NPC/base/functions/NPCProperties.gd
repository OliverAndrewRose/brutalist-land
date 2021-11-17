extends Spatial
class_name NPCProperties

var linear_velocity: Vector3;
var forward_velocity: Vector3;

onready var max_speed: float = $AI_behaviour/pathfinding.speed;
onready var _last_pos: Vector3 = get_global_transform().origin;

func _process(delta):
	_calculate_velocity(delta);
	_calculate_forward_velocity(delta);
	pass


func _calculate_velocity(delta_t: float):
	linear_velocity = (get_global_transform().origin - _last_pos) / delta_t;
	_last_pos = get_global_transform().origin;
	pass

func _calculate_forward_velocity(delta_t: float):
	forward_velocity = -global_transform.basis.xform_inv(linear_velocity);
	pass
