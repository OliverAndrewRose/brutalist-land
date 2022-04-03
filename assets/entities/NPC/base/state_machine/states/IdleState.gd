extends NPC_State
class_name IdleState

export(bool) var debug_cover: bool;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;
onready var npc_properties: NPCProperties = owner as NPCProperties;

func update(_delta: float):
	_process_enemy_detection();
	pass


func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		if npc_properties.does_npc_fight:
			state_machine.transition_to("assault");
		else:
			state_machine.transition_to("hide");
