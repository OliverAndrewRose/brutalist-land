extends AudioStreamPlayer



func _on_MusicPlayer_finished():
	loop_song();

func loop_song():
	play();
