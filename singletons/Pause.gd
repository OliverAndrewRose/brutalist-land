# Singleton
extends Node

var can_press = true
var _menu: Control;


func _ready():
	pause_mode = PAUSE_MODE_PROCESS # This script can't get paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if not Input.is_key_pressed(KEY_ESCAPE):
		can_press = true
	
	if can_press:
		if Input.is_key_pressed(KEY_ESCAPE):
			
			can_press = false
			_menu = get_node("/root/Root/Menu/MenuPanel") as Control;
			
			if get_tree().paused:
				resume_game();
			else:
				pause_game();

func resume_game():
	get_tree().paused = false;
	set_menu_active(false);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	

func pause_game():
	get_tree().paused = true
	set_menu_active(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass


func set_menu_active(is_active: bool):
	if(is_active):
		_menu.open_menu();
	else:
		_menu.close_menu();
	pass
