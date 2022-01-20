extends Node

signal enemy_detected(enemy)
signal enemy_lost(enemy)

onready var detection_area: Area = get_node("fov_detection") as Area;
onready var raycast_detector: RayCast = get_node("cast_detection") as RayCast;

var potential_enemies = {}
var detected_enemies = {};

func _on_fov_detection_body_entered(body: Spatial):
	_track_potential_entitiy(body);

func _track_potential_entitiy(target: Spatial):
	if _check_enemy_team(target):
		#print("Enemy spotted: " + target.name)
		potential_enemies[target] = true;


func _check_enemy_team(target: Spatial):
	
	if not "faction_index" in target:
		return false;
	
	var _faction_relations = get_tree().get_root().get_node("FactionRelations");
	var _relation = _faction_relations.relations[owner.faction_index][target.faction_index];
	if(_relation < 0):
		return true;
	else:
		return false;


# process each enemy in the list to ensure they are still sighted by the raycast.
func _process(_delta):
	_detect_potential_enemies();
	_process_lost_enemies();
	pass;


func _detect_potential_enemies():
	var recently_detected = _return_all_in_line_of_sight(potential_enemies, true);
	for i in recently_detected:
		detected_enemies[i]=true;
		potential_enemies.erase(i);
		emit_signal("enemy_detected",i);
	pass
	

func _return_all_in_line_of_sight(entity_list, in_sight: bool = true):
	var detected = [];
	
	for target in entity_list.keys():
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
	var recently_lost = _return_all_in_line_of_sight(detected_enemies, false);
	for i in recently_lost:
		detected_enemies.erase(i);
		potential_enemies[i]=true;
		emit_signal("enemy_lost",i);
	pass
	

func _on_fov_detection_body_exited(body: Spatial):
	if potential_enemies.has(body):
		potential_enemies.erase(body);
		
	if detected_enemies.has(body):
		detected_enemies.erase(body);
		emit_signal("enemy_lost", body);
