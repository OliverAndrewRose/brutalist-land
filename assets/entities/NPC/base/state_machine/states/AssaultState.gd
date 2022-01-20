extends NPC_State

onready var pathfinder: Pathfinding = owner.get_node("AI_behaviour/pathfinding") as Pathfinding;
onready var ai_helper: AIHelper = owner.get_node("AI_behaviour") as AIHelper;

var target_enemy: Spatial;
var target_destination: Vector3;
var target_is_visible: bool;

func enter(_msg := {}):
	pass


func update(_delta: float):
	_process_target_location();
	_charge_enemy();


func _process_target_location():
	
	if ai_helper.current_enemy != null:
		target_enemy = ai_helper.current_enemy;
		target_destination = target_enemy.get_node("chest_position").get_global_transform().origin;
		target_is_visible = true;
		$enemy_extrapolation_timer.stop();
		$end_pursuit_timer.stop()
		
	elif target_enemy != null and weakref(target_enemy).get_ref():
		target_destination = target_enemy.get_node("chest_position").get_global_transform().origin;
		owner.get_node("Look_Towards").look_towards(target_destination);
		
		if target_is_visible:
			target_is_visible = false;
			$enemy_extrapolation_timer.start();
			$end_pursuit_timer.start();


func _charge_enemy():
	pathfinder.target = target_destination;
	
	
func _on_enemy_extrapolation_timer_timeout():
	target_enemy = null;


func _on_end_pursuit_timer_timeout():
	state_machine.transition_to("patrol");
