extends NPC_State
class_name PatrolState

export(String) var starting_path_node: String;
var patrol_path = [];
var current_node_index: int = 0;
var waiting: bool = false;
onready var node_wait_timer: Timer = Timer.new();
onready var npc_properties: NPCProperties = owner as NPCProperties;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;


func _ready():
	# Set up the timer.
	add_child(node_wait_timer);
	node_wait_timer.connect("timeout", self, "_on_node_wait_timer_timeout");
	node_wait_timer.one_shot = true;
	pass

func enter(_msg := {}) -> void:
	starting_path_node = npc_properties.state_target_marker_name;
	patrol_path = get_tree().get_root().get_node("Root/QodotHelper").collect_all_path_nodes(starting_path_node);
	_goto_current_node();
	pass


func update(_delta: float):
	
	_process_enemy_detection();
	if _has_reached_next_node():
		_on_reached_next_node();


func _has_reached_next_node():
	if(not waiting and owner.get_global_transform().origin.distance_to(patrol_path[current_node_index].get_global_transform().origin) < 3):
		return true;
	return false;


func _on_reached_next_node():
	node_wait_timer.start(patrol_path[current_node_index].wait_time);
	waiting = true;
	pass


func _on_node_wait_timer_timeout():
	node_wait_timer.stop();
	# If they've moved onto a different state, then cancel.
	if state_machine.state.name != self.name:
		return;
	
	current_node_index = (current_node_index + 1) % patrol_path.size();
	waiting = false;
	_goto_current_node(); 
	

func _goto_current_node():
	var path: Pathfinding = ai_behaviour.get_node("pathfinding") as Pathfinding;
	path.target = patrol_path[current_node_index].get_global_transform().origin;
	

func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		if npc_properties.does_npc_fight:
			state_machine.transition_to("assault");
		else:
			state_machine.transition_to("hide");
