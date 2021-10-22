extends Spatial

onready var player = owner.owner

func _process(delta):
	$Camera.translation.x = player.translation.x
	$Camera.translation.z = player.translation.z
	$Camera.rotation_degrees.y = player.rotation_degrees.y
