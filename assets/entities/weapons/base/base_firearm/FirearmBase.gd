extends WeaponBase
class_name FirearmBase

export(PackedScene) var bullet_scene: PackedScene;
export(PackedScene) var shell: PackedScene;
export(int) var bullet_velocity: int = 280;
export(int) var bullet_damage: int = 30;
onready var _light: Light = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/OmniLight") as Light;
onready var _light_timer: Timer = Timer.new();


func _ready():
	_light_timer.connect("timeout", self, "disable_light");
	add_child(_light_timer);
	pass


func fire_weapon():
	.fire_weapon();
	spawn_projectile()
	spawn_shell()
	shoot_light();


func shoot_animation():
	.shoot_animation();
	
	randomize()
	var value = rand_range(0.8, 1)
	var omi_light = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/OmniLight")
	owner.get_node("ShootTween").interpolate_property(omi_light, "light_energy", 0, value, 0.05, Tween.TRANS_SINE, Tween.EASE_OUT)
	owner.get_node("ShootTween").interpolate_property(omi_light, "light_energy", value, 0, 0.05, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.05)


func shoot_light():
	_light.light_energy = 1;
	_light_timer.start(0.02);
	pass


func spawn_projectile():
	var bullet: Bullet = bullet_scene.instance() as Bullet;
	get_tree().get_root().get_node("Root").add_child(bullet);
	bullet.global_transform = owner.get_node("Position3D/LookAt/ShootPosition").get_global_transform();
	bullet.apply_impulse(Vector3.ZERO, -owner.get_node("Position3D/LookAt/ShootPosition").get_global_transform().basis.z * bullet_velocity);
	bullet.bullet_damage = bullet_damage;


func spawn_shell():
	var shell_instance = shell.instance()
	get_tree().get_root().add_child(shell_instance)
	shell_instance.global_transform = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/ShellSpawn").global_transform
	shell_instance.linear_velocity = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/ShellSpawn").global_transform.basis.x * 2.5


func disable_light():
	_light.light_energy = 0;
	_light_timer.stop();
	pass
