extends Node
class_name NPCDialogueInteraction
signal start_interaction;

var interact_text: String = "Talk"

func receive_interaction(_sender: Spatial):
	emit_signal("start_interaction", _sender);
	pass
