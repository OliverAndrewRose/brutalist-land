extends QodotEntity
class_name AddDialogue

export(String) var dialogue: String;
export(PackedScene) var interaction_scene: PackedScene;
var node_height: float = 1.7
var node_radius: float = 0.7
var dialogue_node: Node;
var require_input: bool = true;

var _active_user: Player = null;
var _dialogue_holder_name: String;
var _dialogue_holder: Spatial;
signal dialogic_signal;


func _ready():
	_add_interaction_node();


# Adds the interaction node to the entity, and then connects the interaction signal to this script.
func _add_interaction_node() -> void:
	_dialogue_holder = get_tree().root.get_node("Root/QodotHelper").get_nodes_by_targetname(_dialogue_holder_name)[0];
	var _interaction_node: Spatial = interaction_scene.instance() as Spatial;
	var _interaction_scale = Vector3(node_radius, node_height, node_radius);
	_interaction_node.get_global_transform().scaled(_interaction_scale);
	_dialogue_holder.add_child(_interaction_node);
	_interaction_node.get_global_transform().origin = _dialogue_holder.get_global_transform().origin;
	_interaction_node.connect("start_interaction", self, "receive_dialogue_start");
	pass


func _start_dialogic() -> void:
	dialogue_node = Dialogic.start(dialogue) as Node;
	dialogue_node.connect("dialogic_signal", self, "receive_dialogic_signal")
	dialogue_node.connect("tree_exited", self, "receive_dialogue_end")
	add_child(dialogue_node);
	pass # Replace with function body.


func update_properties() -> void:
	if "dialogue" in properties:
		dialogue = properties.dialogue;
	if "target" in properties:
		_dialogue_holder_name = properties.target;
	if "node_height" in properties:
		node_height = properties.node_height;
	if "node_radius" in properties:
		node_radius = properties.node_radius;
	if "require_input" in properties:
		if(properties.require_input.to_lower() == "true"):
			require_input = true;
		else:
			require_input = false;
	pass


func receive_dialogue_start(_sender) -> void:
	_active_user = _sender as Player;
	
	if require_input:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		_active_user.set_active_input(false);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		
	_start_dialogic();


func receive_dialogue_end() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	if _active_user:
		_active_user.set_active_input(true);
		_active_user = null;


func receive_dialogic_signal(signal_arg) -> void:
	emit_signal("dialogic_signal", signal_arg);
	pass
