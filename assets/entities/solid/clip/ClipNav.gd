extends StaticBody
tool

func _ready():
	if not Engine.editor_hint:
		return;
	
	set_collision_layer(256);
	set_collision_mask(256);
