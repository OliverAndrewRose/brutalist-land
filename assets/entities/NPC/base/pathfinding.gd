extends Spatial;
class_name Pathfinding

var path = [];
var path_node: int;

onready var kinematic_body: KinematicBody = get_parent().get_parent() as KinematicBody;
onready var nav: Navigation = get_node("/root/Root/Navigation") as Navigation;

export(Vector3) var target;
export(float) var speed;

func _ready():
	pass # Replace with function body.

func _physics_process(delta: float):
	_move_to_next_node();
	

func _move_to_next_node():
	
	if(path_node < path.size()):
		var direction: Vector3 = (path[path_node] - global_transform.origin);
		
		if(direction.length() < 0.5):
			path_node +=1;
		else:
			kinematic_body.move_and_slide(direction.normalized() * speed, Vector3.UP);


func _on_path_regen_timeout():
	#target = get_node("/root/Root/Debug_position").global_transform.origin;
	_create_path();
	

func _create_path():
	path = nav.get_simple_path(global_transform.origin, target, true);
