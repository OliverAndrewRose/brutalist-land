extends Node

onready var _relations: FactionRelations = get_tree().get_root().get_node("FactionRelations") as FactionRelations;
onready var _look_for_enemy = owner.get_node("AI_behaviour/look_for_enemy");
onready var _radio_timer: Timer = Timer.new();
export(float) var radio_delay = 5.0;
var _reported_enemy: Spatial;

func _ready():
	self.add_child(_radio_timer);
	_radio_timer.connect("timeout", self, "radio_in_timeout");
	_look_for_enemy.connect("enemy_detected", self, "radio_in_enemy");
	pass

func radio_in_enemy(enemy: Spatial):
	_radio_timer.start(radio_delay);
	_reported_enemy = enemy;
	pass


func radio_in_timeout():
	set_enemy_permanently_hostile();
	pass
	

func set_enemy_permanently_hostile():
	_relations.set_faction_relation(owner.faction_name, _reported_enemy.faction_name, -2);
	pass
