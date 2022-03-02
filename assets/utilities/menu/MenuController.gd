extends Control

onready var pause: Pause = get_node("/root/Pause") as Pause;
var _target_color: Color = Color(1,1,1,0)

onready var _options = $OptionsMenu;

func _ready():
	self.modulate = _target_color;


func _process(delta):
	_process_fade(delta);

func _process_fade(delta):
	self.modulate = self.modulate.linear_interpolate(_target_color, delta * 10);


func resume_game():
	pause.resume_game();
	pass


func restart_level():
	resume_game();
	var scene = get_tree().reload_current_scene();

func quit_game():
	get_tree().quit();


func toggle_options():
	if not _options.visible:
		_options.visible = true;
	else:
		_options.visible = false;
	pass


func open_menu():
	_target_color = Color(1,1,1,1);
	pass


func close_menu():
	_target_color = Color(1,1,1,0);
	pass
