extends WeaponBase
class_name FirearmBase

export(PackedScene) var bullet_scene: PackedScene;
export(PackedScene) var shell: PackedScene;
export(int) var bullet_velocity: int = 280;

func fire_weapon():
	
	spawn_projectile()
	spawn_shell()
	


func spawn_projectile():
	var bullet: Bullet = bullet_scene.instance() as Bullet;
	get_tree().get_root().get_node("Root").add_child(bullet);
	bullet.global_transform = owner.get_node("ShootPosition").get_global_transform();
	bullet.apply_impulse(Vector3.ZERO, -owner.get_node("ShootPosition").get_global_transform().basis.z * bullet_velocity);
	bullet.bullet_damage = 30;


func spawn_shell():
	var shell_instance = shell.instance()
	get_tree().get_root().add_child(shell_instance)
	shell_instance.global_transform = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/ShellSpawn").global_transform
	shell_instance.linear_velocity = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon/ShellSpawn").global_transform.basis.x * 2.5
