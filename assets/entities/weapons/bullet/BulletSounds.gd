extends Spatial

export(AudioStream) onready var bullet_crack_clip;
export(AudioStream) onready var bullet_whiz_clip;
export(PackedScene) onready var bullet_audio_player;

var audio_played: bool = false;
var audio_clip: AudioStream;
const speed_of_sound: float = 343.0;

func _on_bullet_crack_range_body_entered(body):
	
	if get_parent().linear_velocity.length() > speed_of_sound:
		audio_clip = bullet_crack_clip;
	else:
		audio_clip = bullet_whiz_clip;
		
	
	if not audio_played:
		var audio_player = bullet_audio_player.instance();
		get_tree().get_root().add_child(audio_player);
		audio_player.get_global_transform().origin = get_global_transform().origin;
		audio_player.stream = audio_clip;
		audio_player.play();
		audio_played = true;
