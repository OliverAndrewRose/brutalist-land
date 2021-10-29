extends Node

signal character_death;

export(int) var current_health: int = 100;
export(int) var max_health: int = 100;


func take_damage(damage: int):
	current_health = clamp(current_health - damage, 0, max_health);
	
	if(current_health <= 0):
		emit_signal("character_death");


func add_health(health: int):
	current_health = clamp(current_health + health, 0, max_health);
	pass
