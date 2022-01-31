extends Node
class_name NPCHolster

var is_holstered: bool = true;
var preparing_weapon: bool = false;
var holster_delay: float = 1.5;
onready var holster_timer: Timer = Timer.new();
onready var pathfind: Pathfinding = get_node("../../AI_behaviour/pathfinding") as Pathfinding;

func _ready():
	self.add_child(holster_timer);
	holster_timer.connect("timeout", self, "holster_timeout");
	pass


func holster_timeout():
	if is_holstered:
		weapon_unholstered();
	else:
		weapon_holstered();
	pass


func unholster_weapon():
	holster_timer.start(holster_delay);
	preparing_weapon = true;
	pathfind.can_move = false;
	pass


func weapon_unholstered():
	preparing_weapon = false;
	is_holstered = false;
	pathfind.can_move = true;


func holster_weapon():
	holster_timer.start(holster_delay)
	preparing_weapon = true;
	pathfind.can_move = false;


func weapon_holstered():
	preparing_weapon = false;
	is_holstered = true;
	pathfind.can_move = true;
