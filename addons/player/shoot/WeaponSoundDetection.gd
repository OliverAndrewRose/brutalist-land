extends Area

func _on_SoundDetection_body_entered(body):
	
	if "faction_name" in body and "start_state_name" in body:
		_alert_character(body as NPCProperties);

func _alert_character(npc: NPCProperties):
	var _state_machine: StateMachine = npc.get_node("AI_behaviour/state_machine") as StateMachine;
	var _location = self.get_global_transform().origin;
	
	if _state_machine.has_node("investigate") and npc.does_npc_fight:
		_set_to_investigate(_state_machine, _location);
	else:
		_set_to_hide(_state_machine);


# Set the NPC to investigate. Also prevents running several times within a few seconds.
func _set_to_investigate(state_machine: Node, location: Vector3):
	var _investigate = state_machine.get_node("investigate");
	var _investigation_elapse = _investigate.investigation_time - _investigate.investigate_timer.time_left;

	# Check if the NPC has just responded to a noise. Continue otherwise.
	if _investigation_elapse > 2 or state_machine.state.name != "investigate":
		state_machine.transition_to("investigate");
		state_machine.get_node("investigate").investigate_location(location);


# Sets the NPC to hide.
func _set_to_hide(state_machine: Node):
	var _hide = state_machine.get_node("hide");

	# Check if the NPC has just responded to a noise. Continue otherwise.
	if state_machine.state.name != "hide":
		state_machine.transition_to("hide");
