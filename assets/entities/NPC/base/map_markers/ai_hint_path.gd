class_name AIHintPath
extends QodotEntity
tool


export(String) var pathType: String

export(String) var nodeName: String
export(String) var nextNode: String

func update_properties():
	if "pathType" in properties:
		pathType = properties["pathType"];
		
	if "nodeName" in properties:
		nodeName = properties["nodeName"];
		
	if "nextNode" in properties:
		nextNode = properties["nextNode"];
	pass
