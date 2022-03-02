extends QodotEntity;
tool

onready var openCloser: DoorOpenCloser = get_node("Body") as DoorOpenCloser;

func update_properties():
	pass


func _ready():
	if not Engine.editor_hint:
		# Set the lock state of the door.
		if "locked" in properties:
			if properties.locked:
				openCloser.locked = true;
			else:
				openCloser.locked = false;
				
		if "open_forwards" in properties:
			if properties.open_forwards:
				openCloser.open_forwards = true;
			else:
				openCloser.open_forwards = false;
