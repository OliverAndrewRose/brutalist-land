extends AnimationTree

onready var npc_root: NPCProperties = get_node("../..") as NPCProperties;
onready var npc_pathfinding: Pathfinding = get_node("../../AI_behaviour/pathfinding") as Pathfinding;
export(String) var holster_node_dir: String = "../../Aim_and_Shoot/holster_weapon"

func _process(delta: float):
	_process_movement_blend(delta);
	_process_movement_speed();
	_process_swap_to_pistol();
	pass


func _process_movement_blend(delta_t: float):
	var blend_paths: Array;
	blend_paths.append("parameters/StateMachine/unarmed_walk/blend_position");
	blend_paths.append("parameters/StateMachine/unarmed_run/blend_position");
	blend_paths.append("parameters/StateMachine/pistol_walk/blend_position");
	
	var blend_point: Vector2 = get(blend_paths[0]) as Vector2;
	var new_blend_point: Vector2 = Vector2(npc_root.forward_velocity.x, npc_root.forward_velocity.z);
	blend_point = blend_point.linear_interpolate(new_blend_point, delta_t*10);
	
	for i in range(0, blend_paths.size()):
		set(blend_paths[i], blend_point);
	

func _process_movement_speed():
	if npc_pathfinding.is_running:
		set("parameters/StateMachine/conditions/run",true);
		set("parameters/StateMachine/conditions/walk",false);
	else:
		set("parameters/StateMachine/conditions/run",false);
		set("parameters/StateMachine/conditions/walk",true);
	pass


func _process_swap_to_pistol():
	
	var _holster: NPCHolster;
	if has_node(holster_node_dir):
		_holster = get_node(holster_node_dir) as NPCHolster;
	else:
		return
	
	if _holster.preparing_weapon and _holster.is_holstered:
		set("parameters/StateMachine/conditions/unholstering", true);
	elif _holster.preparing_weapon and not _holster.is_holstered:
		set("parameters/StateMachine/conditions/holstering", true);
	else:
		set("parameters/StateMachine/conditions/unholstering", false);
		set("parameters/StateMachine/conditions/holstering", false);
	pass
