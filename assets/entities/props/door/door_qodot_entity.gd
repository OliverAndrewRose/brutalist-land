extends QodotEntity;
tool

func update_properties():
	
	if not Engine.editor_hint:
		return;
	
	if 'angle' in properties:
		self.rotation_degrees = Vector3(rotation_degrees.x,180 + int(properties.angle), rotation_degrees.z);
