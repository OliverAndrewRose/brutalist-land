extends Spatial

onready var player = owner.owner

func _ready():
	#set_map_init();
	pass

func set_map_init():
	$Camera.translation.x = player.translation.x
	$Camera.translation.z = player.translation.z
	$Camera.translation.y = player.translation.y + 1
	pass
