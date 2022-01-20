extends Area;

export(Dictionary) var properties setget set_properties

export(bool) var one_shot = false;
export(bool) var player_only = true;
export(String) var set_faction_trigger: String;

signal on_trigger_enter(entity);
signal on_trigger_exit(entity);


func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()
	
	
func update_properties():
	pass


func _ready():
	connect("body_entered",self,"emit_enter_signal");
	connect("body_exited",self,"emit_exit_signal");
	

func emit_enter_signal(body):
	emit_signal("on_trigger_enter", body);
	pass


func emit_exit_signal(body):
	emit_signal("on_trigger_exit", body);
	pass
