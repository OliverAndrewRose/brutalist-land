extends Node
class_name NPCHolster

var is_holstered: bool = true;
var preparing_weapon: bool = false;
var holster_delay: float = 1.5;
onready var holster_timer: Timer = Timer.new();
onready var pathfind: Pathfinding = get_node("../../AI_behaviour/pathfinding") as Pathfinding;

# Add weapon model variables.
export(NodePath) var weapon_attach_path: NodePath;
onready var weapon_attach: Spatial = get_node(weapon_attach_path) as Spatial;
onready var weap_properties: NpcWeaponProperties = get_node("../weapon_properties") as NpcWeaponProperties;
var weapon_model: Spatial;

func _ready():
	self.add_child(holster_timer);
	holster_timer.connect("timeout", self, "holster_timeout");
	pass


func holster_timeout():
	if is_holstered:
		weapon_unholstered();
	else:
		weapon_holstered();
	pass


func unholster_weapon():
	if not is_holstered:
		return;
	holster_timer.start(holster_delay);
	preparing_weapon = true;
	pathfind.can_move = false;
	add_weapon_model();
	pass


func weapon_unholstered():
	preparing_weapon = false;
	is_holstered = false;
	pathfind.can_move = true;
	holster_timer.stop();


func holster_weapon():
	if is_holstered:
		return;
	holster_timer.start(holster_delay)
	preparing_weapon = true;
	pathfind.can_move = false;


func weapon_holstered():
	preparing_weapon = false;
	is_holstered = true;
	pathfind.can_move = true;
	remove_weapon_model()
	holster_timer.stop();


func add_weapon_model():
	weapon_model = weap_properties.weapon_model.instance() as Spatial;
	weapon_attach.add_child(weapon_model);
	weapon_model.transform.origin = Vector3.ZERO;


func remove_weapon_model():
	if weapon_model != null:
		weapon_model.queue_free();
		weapon_model = null;
