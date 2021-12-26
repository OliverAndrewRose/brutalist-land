extends NPC_State
class_name PatrolState

export(String) var starting_path_node: String;
export(float) var node_wait: int;
var patrol_path = [];
var current_node: int = 0;
var waiting: bool = false;
onready var node_wait_timer = get_node("node_wait_timer");
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

func _ready():
	patrol_path = get_tree().get_root().get_node("Root/QodotHelper").collect_all_path_nodes(starting_path_node);
	pass

func enter(_msg := {}) -> void:
	node_wait_timer.wait_time = node_wait;
	_goto_current_node();
	pass


func update(_delta: float):
	
	_process_enemy_detection();
	if _has_reached_next_node():
		_on_reached_next_node();

func _has_reached_next_node():
	if(not waiting and owner.get_global_transform().origin.distance_to(patrol_path[current_node].get_global_transform().origin) < 3):
		return true;
	return false;

func _on_reached_next_node():
	node_wait_timer.start();
	waiting = true;
	pass


func _on_node_wait_timer_timeout():
	node_wait_timer.stop();
	current_node = (current_node + 1) % patrol_path.size();
	waiting = false;
	_goto_current_node(); 
	

func _goto_current_node():
	var path: Pathfinding = ai_behaviour.get_node("pathfinding") as Pathfinding;
	path.target = patrol_path[current_node].get_global_transform().origin;

func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		state_machine.transition_to("assault");
