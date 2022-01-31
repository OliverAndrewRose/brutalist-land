extends Area;

export(Dictionary) var properties setget set_properties

export(String) var faction_owner;
export(bool) var this_faction_only;

signal on_trigger_enter(entity);
signal on_trigger_exit(entity);

onready var _faction_relations: FactionRelations = get_tree().get_root().get_node("FactionRelations") as FactionRelations;


func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()
	
	
func update_properties():
	
	if "faction_owner" in properties:
		faction_owner = properties.faction_owner;
	
	if "this_faction_only" in properties:
		if properties.this_faction_only.to_lower() == "true":
			this_faction_only = true;
		else:
			this_faction_only = false;
	pass


func _ready():
	connect("body_entered",self,"emit_enter_signal");
	connect("body_exited",self,"emit_exit_signal");

# This faction will engage with the trespasser.DD
func _set_faction_hostile(body: Spatial):
	if "faction_name" in body:
		if body.faction_name != faction_owner:
			_faction_relations.set_faction_relation(faction_owner, body.faction_name, -1);

# The faction will not longer engage with the ex-trespasser.
func _set_faction_neutral(body: Spatial):
	if "faction_name" in body:
		if body.faction_name != faction_owner:
			_faction_relations.set_faction_relation(faction_owner, body.faction_name, 1);


func emit_enter_signal(body):
	emit_signal("on_trigger_enter", body);
	_set_faction_hostile(body);
	pass


func emit_exit_signal(body):
	emit_signal("on_trigger_exit", body);
	_set_faction_neutral(body);
	pass
