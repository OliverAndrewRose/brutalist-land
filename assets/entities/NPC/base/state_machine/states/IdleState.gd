extends NPC_State
class_name IdleState

export(bool) var debug_cover: bool;


func update(delta: float):
	check_for_exit();
	pass


func check_for_exit():
	
	if debug_cover:
		state_machine.transition_to("cover");
	
	pass