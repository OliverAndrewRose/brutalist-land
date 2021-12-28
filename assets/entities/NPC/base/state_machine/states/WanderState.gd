extends NPC_State
class_name WanderState

export(String) var starting_path_node: String;
export(float) var max_wait_time: int = 20;
export(float) var min_wait_time: int = 5;
var central_node: Spatial;
var central_node_name: String;
var max_radius: float = 5;
var waiting: bool = false;
var target_pos: Vector3;

onready var _rand: RandomNumberGenerator = RandomNumberGenerator.new();
onready var wait_timer = Timer.new();
onready var npc_properties: NPCProperties = owner as NPCProperties;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

func _ready():
	add_child(wait_timer);
	_rand.randomize();
	pass

# Create a timer and then go to the first position.
func enter(_msg := {}) -> void:
	wait_timer.connect("timeout", self,"_on_target_wait_timer_timeout");
	central_node_name = npc_properties.state_target_marker_name;
	central_node = get_tree().get_root().get_node("Root/QodotHelper").get_nodes_by_targetname(central_node_name)[0]
	max_radius = central_node.radius;
	_on_target_wait_timer_timeout();
	pass


func update(_delta: float):
	
	_process_enemy_detection();
	if not waiting:
		wait_timer.start(_rand.randf_range(min_wait_time, max_wait_time));
		waiting = true


func _on_target_wait_timer_timeout():
	wait_timer.stop();
	target_pos = _get_new_target_pos();
	waiting = false;
	_goto_current_target(); 
	

func _get_new_target_pos() -> Vector3:
	var _rand_x = _rand.randf_range(-1,1);
	var _rand_y = _rand.randf_range(-1,1);
	_rand_x = sign(_rand_x) * sqrt(pow(_rand_x,2) / pow(_rand_x,2) + pow(_rand_y,2));
	_rand_y = sign(_rand_y) * sqrt(pow(_rand_y,2) / pow(_rand_x,2) + pow(_rand_y,2));
	var _local_pos = Vector3(_rand_x * max_radius, 0, _rand_y * max_radius)
	return central_node.get_global_transform().origin + _local_pos;
	pass

func _goto_current_target():
	var path: Pathfinding = ai_behaviour.get_node("pathfinding") as Pathfinding;
	path.target = target_pos;
	pass

func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		if npc_properties.does_npc_fight:
			state_machine.transition_to("assault");
