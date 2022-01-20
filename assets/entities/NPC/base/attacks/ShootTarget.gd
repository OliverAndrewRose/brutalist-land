extends Node
class_name ShootTarget

onready var weaponProperties: WeaponProperties = get_parent().get_node("weapon_properties") as WeaponProperties;
onready var shoot_origin: Spatial = owner.get_node("shoot_position") as Spatial;

onready var shot_interval_timer: Timer = get_node("shot_interval") as Timer;
onready var lost_visual_timer: Timer = get_node("lost_visual") as Timer;

onready var bullet_scene: PackedScene = weaponProperties.bullet;

var aim_direction: Vector3;
var is_visible: bool = false;
var enemy: Spatial = null;

func _ready():
	shot_interval_timer.wait_time = 1 / weaponProperties.fire_rate;
	pass # Replace with function body.


func _process(_delta: float):
	_check_should_aim_and_shoot();
	pass
	

func _check_should_aim_and_shoot():
	enemy = owner.get_node("AI_behaviour").current_enemy;
	if(enemy != null):
		
		lost_visual_timer.stop() # Enemy is no longer hidden, so stop timer.
		_aim_at_enemy();
		
		if(not is_visible):
			shot_interval_timer.start(); # Begin gunshots
			is_visible = true; # enemy is visible.
	
	elif is_visible:
		is_visible = false;
		lost_visual_timer.start(); # shoot at last position for x seconds.


func _aim_at_enemy():
	
	# Get the Spatial and position of the enemy's chest.
	var aim_body: Spatial = enemy.get_node("chest_position");
	var aim_loc: Vector3 = aim_body.get_global_transform().origin
	var look_direction: Vector3 = Vector3(aim_loc.x, owner.get_global_transform().origin.y, aim_loc.z);
	
	aim_direction = (aim_loc - shoot_origin.get_global_transform().origin).normalized();
	owner.get_node("Look_Towards").look_towards(look_direction);


func _on_lost_visual_timeout():
	shot_interval_timer.stop(); # stop shooting.



func _on_shot_interval_timeout():
	_shoot_weapon();
	pass


func _shoot_weapon():
	var bullet: Bullet = bullet_scene.instance() as Bullet;
	get_tree().get_root().get_node("Root").add_child(bullet);
	bullet.global_translate(shoot_origin.get_global_transform().origin);
	bullet.global_transform.basis.z = -aim_direction;
	bullet.apply_impulse(Vector3.ZERO, aim_direction * weaponProperties.bullet_velocity);
	bullet.bullet_damage = weaponProperties.damage;
	pass
