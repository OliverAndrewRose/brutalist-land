extends Control

func _ready():
	visible = false;
	pass

func _process(delta):
	_process_input();
	pass

func _process_input():
	if Input.is_action_just_pressed("map"):
		if visible:
			visible = false;
		else:
			$ViewportContainer/Viewport/MapScene.set_map_init();
			visible = true;
	pass
