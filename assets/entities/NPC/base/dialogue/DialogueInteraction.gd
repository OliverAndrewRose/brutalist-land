extends Node
class_name NPCDialogueInteraction
signal start_interaction;


func receive_interaction(_sender: Spatial):
	emit_signal("start_interaction", _sender);
	pass
