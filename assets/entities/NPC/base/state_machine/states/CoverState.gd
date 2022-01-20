extends NPC_State
class_name CoverState

var cover_positions = [];
var current_cover: Spatial;

func enter(_msg := {}) -> void:
	current_cover = find_nearest_cover();
	goto_nearest_cover();
	pass


func find_nearest_cover() -> Spatial:
	cover_positions = get_tree().get_nodes_in_group("ai_hint_position");
	var closest_position: Spatial = cover_positions[0] as Spatial;
	var closest_distance = owner.get_global_transform().origin.distance_to(
		closest_position.get_global_transform().origin);
	
	for x in cover_positions:
		var x_distance = owner.get_global_transform().origin.distance_to(
			x.get_global_transform().origin);
			
		if x_distance < closest_distance:
			closest_position = x;
			closest_distance = x_distance;
		
	return closest_position;

	
func goto_nearest_cover() -> void:
	var path: Pathfinding = ai_behaviour.get_node("pathfinding") as Pathfinding;
	path.target = current_cover.get_global_transform().origin;


func update(_delta: float):
	pass


func check_for_exit() -> void:
	pass
