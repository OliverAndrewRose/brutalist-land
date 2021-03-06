extends Node

onready var weapon_properties: NpcWeaponProperties = get_parent().get_node("weapon_properties") as NpcWeaponProperties;
onready var holster = get_node("../holster_weapon");
onready var reload = get_node("../reload_weapon");

onready var _hit_scan: RayCast = $hit_scan;

onready var shot_interval_timer: Timer = get_node("shot_interval") as Timer;
onready var lost_visual_timer: Timer = get_node("lost_visual") as Timer;

onready var _root: Spatial = get_tree().get_root().get_node("Root") as Spatial;

var aim_direction: Vector3;
var is_visible: bool = false;
var is_shooting: bool = false;
var enemy: Spatial = null;

signal on_gunshot();

func _ready():
	pass # Replace with function body.


func _process(_delta: float):
	_check_should_aim_and_shoot();
	pass
	

func _check_should_aim_and_shoot():
	enemy = owner.get_node("AI_behaviour").current_enemy;
	
	if(enemy != null):
		lost_visual_timer.stop() # Enemy is no longer hidden, so stop timer.
		_aim_at_enemy();
		
		if not is_visible: # Checks whether to reset enemy visiblity to true.
			is_visible = true; # enemy is visible.
		
		if holster.is_holstered: # Checks whether they need to unholster.
			if not holster.preparing_weapon:
				holster.unholster_weapon();
			return;
	
		if not is_shooting: # Checks whether to reset enemy visiblity to true.
			shot_interval_timer.start(_calculate_shot_delay()); # Begin gunshots
			is_shooting = true;
		
	
	elif is_visible:
		is_visible = false;
		lost_visual_timer.start(); # shoot at last position for x seconds.


func _aim_at_enemy():
	
	# Get the Spatial and position of the enemy's chest.
	var aim_body: Spatial = enemy.get_node("chest_position");
	var aim_loc: Vector3 = aim_body.get_global_transform().origin
	var look_direction: Vector3 = Vector3(aim_loc.x, owner.get_global_transform().origin.y, aim_loc.z);
	
	aim_direction = (aim_loc - _hit_scan.get_global_transform().origin).normalized();
	owner.get_node("Look_Towards").look_towards(look_direction);


func _calculate_shot_delay() -> float:
	return 1 / rand_range(weapon_properties.min_fire_rate, weapon_properties.max_fire_rate);
	pass


func _on_lost_visual_timeout():
	shot_interval_timer.stop(); # stop shooting.
	is_shooting = false;


func _on_shot_interval_timeout():
	# Check if the NPC has enough ammo before shooting.
	shot_interval_timer.wait_time = _calculate_shot_delay();
	
	if weapon_properties.ammo <= 0:
		if not reload.is_reloading:
			reload.reload_weapon();
	else:
		_shoot_weapon();
	pass


func _shoot_weapon():

	_hit_scan.cast_to = Vector3(0.0, aim_direction.y, -weapon_properties.max_range);
	WeaponFunctions.scan_bullet_hit(_hit_scan, weapon_properties.damage, weapon_properties.hit_force);
	weapon_properties.ammo -= 1;
	emit_signal("on_gunshot");
	
	
