extends NPC_State
class_name HideState

var hide_nodes = [];
var current_node: Spatial;
var current_node_index: int = 0;
var hiding: bool = false;

onready var node_wait_timer = get_node("node_wait_timer");
export(float) var node_wait_time: int;

onready var npc_properties: NPCProperties = owner as NPCProperties;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;
onready var path: Pathfinding = ai_helper.get_node("pathfinding") as Pathfinding;

func _ready():
	hide_nodes = get_tree().get_root().get_node("Root/QodotHelper").get_nodes_by_attribute_value("locationType", "hide");
	pass

func enter(_msg := {}) -> void:
	current_node = _find_nearest_hiding_spot();
	path.set_to_run(true);
	_goto_current_node();
	pass


func update(_delta: float):
	pass


func _find_nearest_hiding_spot() -> Spatial:
	
	var closest_node = hide_nodes[0];
	var closest_distance = (closest_node.global_transform.origin - owner.global_transform.origin).length()
	
	for node in hide_nodes:
		var distance = (node.global_transform.origin - owner.global_transform.origin).length();
		
		if distance < closest_distance:
			closest_distance = distance;
			closest_node = node;
	
	return closest_node;


func _goto_current_node():
	path.target = current_node.get_global_transform().origin;


func _on_node_wait_timer_timeout():
	node_wait_timer.stop();
	hiding = false;
	path.set_to_run(false);
	state_machine.transition_to(npc_properties.start_state_name);
