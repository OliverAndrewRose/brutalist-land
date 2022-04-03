extends NPC_State

onready var pathfinder: Pathfinding = owner.get_node("AI_behaviour/pathfinding") as Pathfinding;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;
onready var holster = ai_helper.get_node("../Aim_and_Shoot/holster_weapon") as NPCHolster;

export(float) var investigation_time: float = 20.0;
var investigate_location: Vector3;
var investigate_timer: Timer = Timer.new();

func enter(_msg := {}):
	pass

func _ready():
	add_child(investigate_timer);
	investigate_timer.connect("timeout",self,"_on_end_investigate_timer_timeout");

func _process(delta):
	_process_enemy_detection();

func investigate_location(location: Vector3):
	pathfinder.look_towards.look_toward = location;
	pathfinder.target = location;
	holster.unholster_weapon();
	investigate_timer.start(investigation_time);


func _on_end_investigate_timer_timeout():
	investigate_timer.stop();
	holster.holster_weapon();
	state_machine.transition_to(owner.start_state_name);


func _process_enemy_detection():
	if ai_helper.current_enemy != null:
		state_machine.transition_to("assault");
