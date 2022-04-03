extends NPC_State
class_name GuardState

export(String) var starting_path_node: String;
export(float) var max_wait_time: int = 20;
export(float) var min_wait_time: int = 5;

var guard_node: Spatial;
var guard_node_name: String;
var target_pos: Vector3;

onready var guard_refresh_timer = Timer.new();
export(float) var guard_refresh_interval: float = 10.0;

onready var npc_properties: NPCProperties = owner as NPCProperties;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

func _ready():
	add_child(guard_refresh_timer);
	guard_refresh_timer.connect("timeout", self,"_on_guard_refresh_timer_timeout");
	guard_refresh_timer.one_shot = false;

# Create a timer and then go to the guard position.
func enter(_msg := {}) -> void:
	
	# Sets the guard node.
	guard_node_name = npc_properties.state_target_marker_name;
	guard_node = get_tree().get_root().get_node("Root/QodotHelper").get_nodes_by_targetname(guard_node_name)[0]
	
	guard_refresh_timer.start(guard_refresh_interval);



func _on_guard_refresh_timer_timeout():
	target_pos = guard_node.get_global_transform().origin;
	if state_machine.state.name == self.name:
		# Makes the NPC go to the guard node. Also look towards the node's rotation.
		npc_properties.get_node("Look_Towards").look_toward = npc_properties.get_global_transform().origin - guard_node.get_global_transform().basis.z
		_goto_current_target();

func _goto_current_target():
	var path: Pathfinding = ai_behaviour.get_node("pathfinding") as Pathfinding;
	path.target = target_pos;


func update(_delta: float):
	_process_enemy_detection();


func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		if npc_properties.does_npc_fight:
			state_machine.transition_to("assault");
		else:
			state_machine.transition_to("hide");

func exit():
	guard_refresh_timer.stop();
