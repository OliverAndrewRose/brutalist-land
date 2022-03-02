extends KinematicBody
class_name DoorOpenCloser

export(bool) var open_forwards: bool = false;
export(AudioStream) var open_sound: AudioStream;
export(AudioStream) var close_sound: AudioStream;
export(AudioStream) var locked_sound: AudioStream;

onready var _animation_player: AnimationPlayer = $AnimationPlayer; 
onready var _audio_player: AudioStreamPlayer3D = $DoorAudioOutput;
var _is_active: bool = false;

var door_is_open: bool = false;
var locked: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func receive_interaction(_user: Spatial):
	toggle_door_state();
	pass

func toggle_door_state():
	
	#End here if the door is currently active.
	if _is_active:
		return;
	
	if locked:
		_play_locked_sound();
		return;
		
	if door_is_open:
		_close_door();
		_is_active = true;
	else:
		_open_door();
		_is_active = true;
	pass


func _open_door():

	if open_forwards:
		_animation_player.play("door_open_forward");
	else:
		_animation_player.play("door_open_backward");
	
	_audio_player.stream = open_sound;
	_audio_player.play();
	door_is_open = true;


func _close_door():
	
	if open_forwards:
		_animation_player.play("door_close_forward");
	else:
		_animation_player.play("door_close_backward")
	
	_audio_player.stream = close_sound;
	_audio_player.play();
	door_is_open = false;


func _play_locked_sound():
	_audio_player.stream = locked_sound;
	_audio_player.play();


# Ignore the locked state of the door.
func force_door_open():
	_open_door();
	pass


func _on_AnimationPlayer_animation_finished(_anim_name):
	_is_active = false;
