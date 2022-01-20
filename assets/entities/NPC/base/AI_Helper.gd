extends Spatial
class_name AIHelper

var current_enemy: Spatial;
var enemies = {};

var mobility_check_countdown: float = 10;
var mobility_countdown_timeleft: float = 10;
var is_mobile: bool = false;
var min_mobile_move_distance = 1;
var _last_pos: Vector3;
var _timer_active: bool = false;


func _on_look_for_enemy_enemy_lost(enemy):
	enemies.erase(enemy);
	current_enemy = get_nearest_enemy();
	pass # Replace with function body.


func _on_look_for_enemy_enemy_detected(enemy):
	enemies[enemy] = true;
	current_enemy = get_nearest_enemy();
	pass # Replace with function body.


func get_nearest_enemy() -> Spatial:
	
	var enemy_array = enemies.keys();
	
	if(enemy_array.size() < 1):
		return null;
	
	var closest_enemy: Spatial = enemy_array[0] as Spatial;
	var closest_distance = owner.get_global_transform().origin.distance_to(
		closest_enemy.get_global_transform().origin);
	
	for x in enemy_array:
		var x_distance = owner.get_global_transform().origin.distance_to(
			x.get_global_transform().origin);
			
		if x_distance < closest_distance:
			closest_enemy = x;
			closest_distance = x_distance;
		
	return closest_enemy;


func _process(_delta):
	#check_if_mobile(delta);
	pass

# Checks to see if the NPC is mobile.
func check_if_mobile(delta: float):
	
	# If the npc hasn't moved a certain distance, then begin timer, if its inactive.
	if _last_pos.distance_to(get_global_transform().origin) < min_mobile_move_distance:
		if(not _timer_active and is_mobile):
			mobility_countdown_timeleft = mobility_check_countdown;
			_timer_active = true;
			
		# counts down the timer.
		if(_timer_active):
			mobility_countdown_timeleft -= delta;
		
		# On timer time out.
		if(mobility_countdown_timeleft <= 0):
			mobility_check_timeout();
	else:
		is_mobile = true;
		_last_pos = get_global_transform().origin;
		_timer_active = false;
		pass
	pass
	
# If the time times out, then the NPC is immobile.
func mobility_check_timeout():
	is_mobile = false;
	_timer_active = false;
	pass
