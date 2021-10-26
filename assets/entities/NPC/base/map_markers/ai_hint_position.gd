class_name AIHintPosition
extends QodotEntity
tool


export(String) var locationType: String

func update_properties():
	if "locationType" in properties:
		locationType = properties["locationType"];
	pass
