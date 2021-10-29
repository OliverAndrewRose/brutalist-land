extends NPC_State
class_name PatrolState

export(String) var starting_path_node: String;
export(float) var node_wait: int;
var patrol_path = [];
var current_node: int = 0;
var waiting: bool = false;
onready var node_wait_timer = get_node("node_wait_timer");

func enter(_msg := {}) -> void:
	node_wait_timer.wait_time = node_wait;
	_collect_all_path_nodes();
	_goto_current_node();
	pass


func _collect_all_path_nodes():
	var all_path_nodes = get_tree().get_nodes_in_group("ai_hint_path");
	var path_names = []
	
	var next_path_node = starting_path_node;
	var current_path_size = 0;
	var path_finished: bool;
	
	while not path_finished:
		
		for path_node in all_path_nodes:
			if path_node.nodeName == next_path_node:
				patrol_path.append(path_node);
				path_names.append(path_node.nodeName);
				next_path_node = path_node.nextNode;
		
		if(current_path_size != patrol_path.size() + 1):
			path_finished = true;
		else:
			current_path_size += 1;
		
		if path_names.has(next_path_node) or next_path_node == "":
			path_finished = true;


func update(delta: float):
	if(not waiting and owner.get_global_transform().origin.distance_to(patrol_path[current_node].get_global_transform().origin) < 3):
		_on_reached_next_node();
	pass


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

