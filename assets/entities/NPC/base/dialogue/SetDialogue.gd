extends QodotEntity
class_name AddDialogue

export(String) var dialogue: String;
export(PackedScene) var interaction_scene: PackedScene;
var dialogue_node: Node;
var _active_user: Player = null;
var _npc_name: String;
var _npc: Spatial;
signal dialogue_signal;


func _ready():
	_add_interaction_node();

# Adds the interaction node to the NPC, and then connects the interaction signal to this script.
func _add_interaction_node() -> void:
	_npc = get_tree().root.get_node("Root/QodotHelper").get_nodes_by_targetname(_npc_name)[0];
	var _interaction_node: NPCDialogueInteraction = interaction_scene.instance();
	_npc.add_child(_interaction_node);
	_interaction_node.get_global_transform().origin = _npc.get_global_transform().origin;
	_interaction_node.connect("start_interaction", self, "receive_dialogue_start");
	pass


func _start_dialogic() -> void:
	dialogue_node = Dialogic.start(dialogue, '', "res://addons/dialogic/Nodes/DialogNode.tscn", false, true) as Node;
	dialogue_node.connect("dialogue_signal", self, "receive_dialogue_signal")
	dialogue_node.connect("tree_exited", self, "receive_dialogue_end")
	add_child(dialogue_node);
	pass # Replace with function body.

func update_properties() -> void:
	if "dialogue" in properties:
		dialogue = properties.dialogue;
	if "target" in properties:
		_npc_name = properties.target;
	pass


func receive_dialogue_start(_sender) -> void:
	_active_user = _sender as Player;
	_active_user.set_active_input(false);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	_start_dialogic();


func receive_dialogue_end() -> void:
	_active_user.set_active_input(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	_active_user = null;


func receive_dialogue_signal(signal_arg) -> void:
	emit_signal("dialogue_signal", signal_arg);
	pass
