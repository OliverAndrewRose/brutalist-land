extends QodotEntity;
tool

func update_properties():
	
	if not Engine.editor_hint:
		return;
	
	if 'angle' in properties:
		self.rotate(Vector3.UP, deg2rad(180+int(properties.angle)));
