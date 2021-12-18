extends AudioStreamPlayer3D
class_name PlayThenDeletePlayer

func _ready():
	connect("finished", self, "delete_self");
	
func delete_self():
	queue_free();
