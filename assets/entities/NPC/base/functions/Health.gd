extends Node
class_name Health

signal character_death(bodypart_path, force);
signal character_damaged();

export(int) var current_health: int = 100;
export(int) var max_health: int = 100;
export(bool) var god_mode: bool = false;
var is_dead: bool = false;


func take_damage_and_force(damage: int, bodypart_path: String, force: Vector3):
	if god_mode:
		return;
		
	current_health = clamp(current_health - damage, 0, max_health);
	emit_signal("character_damaged");
		
	if(current_health <= 0 and not is_dead):
		emit_signal("character_death", bodypart_path, force);
		is_dead = true


func take_damage(damage: int):
	if god_mode:
		return;
		
	current_health = clamp(current_health - damage, 0, max_health);
	emit_signal("character_damaged");
	
	if(current_health <= 0 and not is_dead):
		emit_signal("character_death", null, null);
		is_dead = true


func add_health(health: int):
	current_health = clamp(current_health + health, 0, max_health);
	pass
