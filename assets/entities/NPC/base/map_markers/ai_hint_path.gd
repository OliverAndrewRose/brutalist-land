class_name AIHintPath
extends QodotEntity
tool


export(String) var pathType: String

export(String) var nodeName: String
export(String) var nextNode: String
export(float) var wait_time: float;

func update_properties():
	if "pathType" in properties:
		pathType = properties["pathType"];
		
	if "targetname" in properties:
		nodeName = properties["targetname"];
		
	if "target" in properties:
		nextNode = properties["target"];
	
	if "waitTime" in properties:
		wait_time = properties.waitTime;
