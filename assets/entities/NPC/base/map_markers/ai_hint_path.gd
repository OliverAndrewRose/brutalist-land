class_name AIHintPath
extends QodotEntity
tool


export(String) var pathType: String

export(String) var nodeName: String
export(String) var nextNode: String

func update_properties():
	if "pathType" in properties:
		pathType = properties["pathType"];
		
	if "targetname" in properties:
		nodeName = properties["targetname"];
		
	if "target" in properties:
		nextNode = properties["target"];
	pass
