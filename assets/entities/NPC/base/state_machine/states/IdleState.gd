extends NPC_State
class_name IdleState

export(bool) var debug_cover: bool;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

func update(_delta: float):
	_process_enemy_detection();
	pass


func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		state_machine.transition_to("assault");
