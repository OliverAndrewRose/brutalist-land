extends Node
class_name AIHelper

var current_enemy: Spatial;
var enemies = {};


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
