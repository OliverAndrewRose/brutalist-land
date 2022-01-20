extends QodotEntity
class_name NPCProperties

var linear_velocity: Vector3;
var forward_velocity: Vector3;
var target_name: String;
var start_state_name: String = "idle";
var state_target_marker_name: String;
export(int) var faction_index = 1;

export(bool) var does_npc_fight: bool = true;

onready var max_speed: float = $AI_behaviour/pathfinding.run_speed;
onready var _last_pos: Vector3 = get_global_transform().origin;

func _process(delta):
	_calculate_velocity(delta);
	_calculate_forward_velocity(delta);
	pass


func _calculate_velocity(delta_t: float):
	linear_velocity = (get_global_transform().origin - _last_pos) / delta_t;
	_last_pos = get_global_transform().origin;
	pass

func _calculate_forward_velocity(_delta_t: float):
	forward_velocity = -global_transform.basis.xform_inv(linear_velocity);
	pass


func update_properties() -> void:
	if "targetname" in properties:
		target_name = properties.targetname;
	if "faction_index" in properties:
		faction_index = properties.faction_index;
	if "start_state" in properties:
		start_state_name = properties.start_state;
	if "state_target_marker" in properties:
		state_target_marker_name = properties.state_target_marker;
	pass
