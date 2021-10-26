extends Node

signal enemy_detected(enemy)
signal enemy_lost(enemy)

onready var detection_area: Area = get_node("fov_detection") as Area;
onready var raycast_detector: RayCast = get_node("cast_detection") as RayCast;

var potential_entities = {}
var detected_entities = {};

func _on_fov_detection_body_entered(body: Spatial):
	_track_potential_entitiy(body);

func _track_potential_entitiy(target: Spatial):
	if _check_enemy_team(target):
		potential_entities[target] = true;


func _check_enemy_team(target: Spatial):
	if(target.is_in_group("Player")):
		return true;
	else:
		return false;


# process each enemy in the list to ensure they are still sighted by the raycast.
func _process(delta):
	_detect_potential_enemies();
	_process_lost_enemies();
	pass;


func _detect_potential_enemies():
	var recently_detected = _return_all_in_line_of_sight(potential_entities, true);
	for i in recently_detected:
		detected_entities[i]=true;
		potential_entities.keys().erase(i);
		emit_signal("enemy_detected",i);
	pass
	

func _return_all_in_line_of_sight(entity_list, in_sight: bool = true):
	var detected = [];
	
	for target in entity_list.keys():
		print(_check_line_of_sight(target));
		if _check_line_of_sight(target) == in_sight:
			detected.append(target);
			
	return detected;


func _check_line_of_sight(target: Spatial):
	var global_cast_direction = target.get_node("head_position").get_global_transform().origin;
	var local_cast_direction = owner.get_node("head_position").to_local(global_cast_direction);
	
	raycast_detector.cast_to = local_cast_direction * 100;
	raycast_detector.force_raycast_update();
	var detected_body: Spatial = raycast_detector.get_collider() as Spatial;

	if(detected_body == target):
		return true;
	else:
		return false;


func _process_lost_enemies():
	var recently_lost = _return_all_in_line_of_sight(detected_entities, false);
	for i in recently_lost:
		detected_entities.keys().erase(i);
		emit_signal("enemy_lost",i);
	pass
	

func _on_fov_detection_body_exited(body: Spatial):
	if potential_entities.has(body):
		potential_entities.keys().erase(body);
		
	if detected_entities.has(body):
		detected_entities.keys().erase(body);
		emit_signal("enemy_lost", body);
