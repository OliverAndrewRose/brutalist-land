extends Node


export(NodePath) var qodot_map_path: NodePath;
onready var qodot_map: QodotMap = get_node(qodot_map_path) as QodotMap;

# Collected all path nodes from a starting path node.
func collect_all_path_nodes(starting_path_node: String) -> Array:
	var all_path_nodes = get_tree().get_nodes_in_group("ai_hint_path");
	var path_names = []
	var patrol_path = []
	
	var next_path_node = starting_path_node;
	var current_path_size = 0;
	var path_finished: bool;
	
	while not path_finished:
		
		for path_node in all_path_nodes:
			if path_node.nodeName == next_path_node:
				patrol_path.append(path_node);
				path_names.append(path_node.nodeName);
				next_path_node = path_node.nextNode;
		
		
		if path_names.has(next_path_node) or next_path_node == "" or next_path_node == null:
			path_finished = true;
			
	return patrol_path;


func get_nodes_by_targetname(targetname: String) -> Array:
	var nodes := []

	for node_idx in range(0, qodot_map.get_child_count()):
		var node = qodot_map.get_child(node_idx)
		if not node:
			continue
			
		var entity_properties;
		if "properties" in node:
			entity_properties = node.properties;
		else:
			continue
			
		if not 'targetname' in entity_properties:
			continue

		if entity_properties['targetname'] == targetname:
			nodes.append(node)

	return nodes

# Collects nodes with a specific arribute value.
func get_nodes_by_attribute_value(attribute: String, value: String) -> Array:
	var nodes := []

	for node_idx in range(0, qodot_map.get_child_count()):
		var node = qodot_map.get_child(node_idx)
		if not node:
			continue
			
		var entity_properties;
		if "properties" in node:
			entity_properties = node.properties;
		else:
			continue
			
		if not attribute  in entity_properties:
			continue

		if entity_properties[attribute] == value:
			nodes.append(node)

	return nodes
