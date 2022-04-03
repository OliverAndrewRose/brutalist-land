extends WeaponBase
class_name FirearmBase

export(int) var damage: int = 40;

export(bool) var gunshot_light_active: bool = true
onready var _light: Light = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/OmniLight") as Light;
onready var _light_timer: Timer = Timer.new();

# Hit scan variables
export var max_range: float = 100.0;
export var hit_force: float = 500.0;
onready var _hit_scan: RayCast = owner.get_node("BulletSpread/RayCast/HitScan") as RayCast;


func _ready():
	randomize()
	# Timer set-up
	_light_timer.connect("timeout", self, "disable_light");
	add_child(_light_timer);


func fire_weapon():
	
	# Set up hit scan range, and then cast a bullet scan.
	_hit_scan.cast_to.z = -max_range
	WeaponFunctions.scan_bullet_hit(_hit_scan, damage, hit_force);
	
	shoot_animation();
	
	if gunshot_light_active:
		shoot_light();

# Player the shoot animation.
func shoot_animation():
	.shoot_animation();


func shoot_light():
	_light.light_energy = 1;
	_light_timer.start(0.05);
	var value = rand_range(0.8, 1)
	var omi_light = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/OmniLight")
	owner.get_node("ShootTween").interpolate_property(omi_light, "light_energy", 0, value, 0.05, Tween.TRANS_SINE, Tween.EASE_OUT)
	owner.get_node("ShootTween").interpolate_property(omi_light, "light_energy", value, 0, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.05)


func disable_light():
	_light.light_energy = 0;
	_light_timer.stop();
	pass
