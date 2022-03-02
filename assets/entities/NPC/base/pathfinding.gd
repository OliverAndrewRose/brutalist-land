extends Spatial;
class_name Pathfinding

var path = [];
var path_node: int;
var can_move: bool = true;
export(PackedScene) var debug_model: PackedScene;

onready var kinematic_body: KinematicBody = get_parent().get_parent() as KinematicBody;
onready var npc_root: NPCProperties = owner as NPCProperties;
onready var nav: Navigation = get_node("/root/Root/Navigation") as Navigation;
onready var look_towards: LookTowards = owner.get_node("Look_Towards") as LookTowards;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

export(Vector3) var target: Vector3;
export (float) var walk_speed: float = 6;
export(float) var run_speed: float = 15;
export(float) var current_speed;
var is_running: bool = false;

var _direction: Vector3;
var _move_vector: Vector3;

func _ready():
	current_speed = walk_speed;
	target = self.global_transform.origin;
	pass # Replace with function body.

func _physics_process(delta: float):
	
	if(path_node < path.size() and can_move):
		_move_to_next_node(delta);
		pass
		
	_process_gravity(delta);
	pass
	

func _move_to_next_node(delta_t: float):
	
	_direction = (path[path_node] - global_transform.origin);
	if(_direction.length() < 1):
		path_node = clamp(path_node + 1,0, path.size()-1);
		_look_towards_path();
	else:
		#_move_vector = npc_root.linear_velocity.linear_interpolate(_direction.normalized() * current_speed,delta_t*10);
		_move_vector = _direction.normalized() * current_speed * delta_t * 20;
		kinematic_body.move_and_slide(_move_vector, Vector3.UP);


func _process_gravity(delta: float):
	if not kinematic_body.is_on_floor():
		kinematic_body.move_and_slide(Vector3.DOWN * 9.81 * delta, Vector3.UP);
	pass


func _look_towards_path():
	
	# If there's an enemy, don't look towards the path.
	if ai_helper.current_enemy != null:
		return null;
	
	var look_direction: Vector3 = path[path_node];
	look_towards.look_towards(look_direction);
	pass


func _on_path_regen_timeout():
	#target = get_node("/root/Root/Debug_position").global_transform.origin;
	if target.distance_to(global_transform.origin) > 5:
		_create_path();
	

func _create_path():
	path = nav.get_simple_path(global_transform.origin, target, true);
	path_node = 0;
	#_debug_path();

# Sets the NPC to run if the parameter is true.
func set_to_run(should_run: bool):
	is_running = should_run;
	
	if should_run:
		current_speed = run_speed;
	else:
		should_run = walk_speed;


func _debug_path():
	for i in path:
		var model = debug_model.instance();
		get_tree().get_root().get_node("Root").add_child(model);
		model.global_transform.origin = i;
