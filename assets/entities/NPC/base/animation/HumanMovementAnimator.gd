extends AnimationTree

onready var npc_root: NPCProperties = get_node("../..") as NPCProperties;


func _process(delta: float):
	_process_movement_blend(delta);
	_process_swap_to_pistol();
	pass


func _process_movement_blend(delta_t: float):
	var blend_path: String = "parameters/StateMachine/unarmed_walk/blend_position";
	var blend_point: Vector2 = get(blend_path) as Vector2;
	var new_blend_point: Vector2 = Vector2(npc_root.forward_velocity.x, npc_root.forward_velocity.z);
	blend_point = blend_point.linear_interpolate(new_blend_point, delta_t*10);
	set(blend_path, blend_point);
	#print(get(blend_path));


func _process_swap_to_pistol():
	var _holster: NPCHolster = get_node("../../Aim_and_Shoot/holster_weapon") as NPCHolster;
	if _holster == null:
		return;
	
	if _holster.preparing_weapon and _holster.is_holstered:
		set("parameters/StateMachine/conditions/unholstering", true);
	elif _holster.preparing_weapon and not _holster.is_holstered:
		set("parameters/StateMachine/conditions/holstering", true);
	else:
		set("parameters/StateMachine/conditions/unholstering", false);
		set("parameters/StateMachine/conditions/holstering", false);
	pass
