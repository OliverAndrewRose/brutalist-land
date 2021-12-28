extends AnimationTree

onready var npc_root: NPCProperties = get_node("../..") as NPCProperties;

func _process(delta: float):
	_process_movement_blend(delta);
	pass


func _process_movement_blend(delta_t: float):
	var blend_path: String = "parameters/movement_dir/blend_position";
	var blend_point: Vector2 = get(blend_path) as Vector2;
	var new_blend_point: Vector2 = Vector2(npc_root.forward_velocity.x, npc_root.forward_velocity.z);
	blend_point = blend_point.linear_interpolate(new_blend_point, delta_t*10);
	set(blend_path, blend_point);
	#print(get(blend_path));
