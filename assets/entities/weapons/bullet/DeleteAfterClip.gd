extends AudioStreamPlayer3D


func _on_bullet_crack_finished():
	queue_free();
