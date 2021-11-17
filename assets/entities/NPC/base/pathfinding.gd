extends Spatial;
class_name Pathfinding

var path = [];
var path_node: int;
export(PackedScene) var debug_model: PackedScene;

onready var kinematic_body: KinematicBody = get_parent().get_parent() as KinematicBody;
onready var npc_root: NPCProperties = owner as NPCProperties;
onready var nav: Navigation = get_node("/root/Root/Navigation") as Navigation;

export(Vector3) var target: Vector3;
export(float) var speed: float;

func _ready():
	pass # Replace with function body.

func _physics_process(delta: float):
	
	_move_to_next_node(delta);
	

func _move_to_next_node(delta_t: float):
	
	if(path_node < path.size()):
		var direction: Vector3 = (path[path_node] - global_transform.origin);
		
		if(direction.length() < 1):
			path_node = clamp(path_node + 1,0, path.size()-1);
			_look_towards_path();
		else:
			var move_dir: Vector3 = npc_root.linear_velocity.linear_interpolate(direction.normalized() * speed,delta_t*10);
			kinematic_body.move_and_slide(move_dir, Vector3.UP);


func _look_towards_path():
	
	# If there's an enemy, don't look towards the path.
	if owner.get_node("AI_behaviour").current_enemy != null:
		return null;
	
	var look_direction: Vector3 = path[path_node];
	owner.get_node("Look_Towards").look_towards(look_direction);
	pass


func _on_path_regen_timeout():
	#target = get_node("/root/Root/Debug_position").global_transform.origin;
	if target.distance_to(global_transform.origin) > 5:
		_create_path();
	

func _create_path():
	path = nav.get_simple_path(global_transform.origin, target, true);
	path_node = 0;
	#_debug_path();


func _debug_path():
	for i in path:
		var model = debug_model.instance();
		get_tree().get_root().get_node("Root").add_child(model);
		model.global_transform.origin = i;
