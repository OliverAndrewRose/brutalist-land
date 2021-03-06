extends Node

signal enemy_detected(enemy)
signal enemy_lost(enemy)

onready var detection_area: Area = get_node("fov_detection") as Area;
onready var raycast_detector: RayCast = get_node("cast_detection") as RayCast;
onready var _faction_relations = get_tree().get_root().get_node("FactionRelations");

onready var _head_pos: Spatial = owner.get_node("head_position") as Spatial;

var potential_enemies = {}
var detected_enemies = {};

# A seperate detection tick rate to reduce performance cost.
onready var detection_tick_timer: Timer = Timer.new();
var detection_tick: float = 1.0 / 40.0; # Tick rate.

func _ready():
	add_child(detection_tick_timer);
	# Disabled custom tick process for now.
	#detection_tick_timer.connect("timeout", self, "_on_tick_process");
	#detection_tick_timer.start(detection_tick);


func _physics_process(delta):
	_on_tick_process(); # Uses physics process.


func _on_tick_process():
	if potential_enemies.size() > 0: # Only run if there are potential enemies.
		_detect_potential_enemies();
		_process_lost_enemies();
	pass;

func _on_fov_detection_body_entered(body: Spatial):
	_track_potential_entitiy(body);

func _track_potential_entitiy(target: Spatial):
	#
	if "faction_name" in target:
		#print("Enemy spotted: " + target.name)
		potential_enemies[target] = true;


func _detect_potential_enemies():
	var recently_detected = _check_entites_in_line_of_sight(potential_enemies, true);
	for i in recently_detected:
		if _check_enemy_team(i):
			detected_enemies[i]=true;
			potential_enemies.erase(i);
			emit_signal("enemy_detected",i);
	pass
	

# The second parameter will decide whether the method returns those
# in the list who are in sight, or those who are not.
func _check_entites_in_line_of_sight(entity_list, in_sight: bool = true):
	var detected = [];
	
	for target in entity_list.keys():
		if _check_line_of_sight(target) == in_sight:
			detected.append(target);
			
	return detected;


func _check_line_of_sight(target: Spatial):
	var global_cast_direction = target.get_node("head_position").get_global_transform().origin;
	var local_cast_direction = _head_pos.to_local(global_cast_direction);
	
	raycast_detector.cast_to = local_cast_direction * 100;
	raycast_detector.force_raycast_update();
	var detected_body: Spatial = raycast_detector.get_collider() as Spatial;

	if(detected_body == target):
		return true;
	else:
		return false;


func _check_enemy_team(target: Spatial):
	
	if not "faction_name" in target:
		return false;
	
	var _relation = _faction_relations.get_faction_relation(owner.faction_name, target.faction_name);
	if(_relation < 0):
		return true;
	else:
		return false;


func _process_lost_enemies():
	var recently_lost = _check_entites_in_line_of_sight(detected_enemies, false);
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
