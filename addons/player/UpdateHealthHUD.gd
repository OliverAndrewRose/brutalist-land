extends Node

export(NodePath) var health_HUD_path: NodePath;
onready var health_HUD: Label = get_node(health_HUD_path) as Label;

func update_health_hud():
	health_HUD.text = get_node("..").current_health as String;
	print(get_node("..").current_health as String)
