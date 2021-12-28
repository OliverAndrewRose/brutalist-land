class_name AIHintPosition
extends QodotEntity
tool


export(String) var locationType: String
var pos_name: String;
var radius: float = 0.0;

func update_properties():
	if "locationType" in properties:
		locationType = properties["locationType"];
	if "targetname" in properties:
		pos_name = properties.targetname;
	if "radius" in properties:
		radius = properties.radius;
	pass
