extends Spatial
onready var skeleton: Skeleton = $Armature/Skeleton as Skeleton;


# Called when the node enters the scene tree for the first time.
func _ready():
	skeleton.physical_bones_start_simulation();
	pass # Replace with function body.

