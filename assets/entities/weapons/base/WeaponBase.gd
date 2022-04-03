extends Node
class_name WeaponBase


export(String) var weapon_name = "M1911";
export(AudioStream) var shoot_sound;
export(AudioStream) var reload_sound;
export(PackedScene) var weapon_model;

export(int) var current_ammo: int = 15;
export(int) var max_ammo: int = 20;
export(int) var total_ammo: int = 300;

export(float) var fire_rate: float = 10;
export(int) var bullet_spread: int = 30;
export(bool) var single_shot: bool = true;
export(bool) var hide_ammo_hud: bool = false;

export(float) var weapon_z_position: float = -0.3;
export(bool) var will_alert: bool = true;
export(float) var max_sound_distance: float = 20.0;

func fire_weapon() -> void:
	shoot_animation();
	pass


func process_reload() -> void:
	play_reload_animation();
	pass


func shoot_animation():
	var animator = owner.current_weapon_model.get_node("AnimationPlayer") as AnimationPlayer;
	animator.stop()
	animator.play("fire_regular")


func play_reload_animation() -> void:
	
	var weapon = owner.get_node("Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon");
	owner.get_node("ReloadTween").interpolate_property(weapon, "rotation_degrees:x", 0, -60, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	owner.get_node("ReloadTween").interpolate_property(weapon, "rotation_degrees:x", -60, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	owner.get_node("ReloadTween").interpolate_property(weapon, "translation:y", 0, -0.2, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	owner.get_node("ReloadTween").interpolate_property(weapon, "translation:y", -0.2, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	owner.get_node("ReloadTween").interpolate_property(weapon, "translation:z", 0, 0.4, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	owner.get_node("ReloadTween").interpolate_property(weapon, "translation:z", 0.4, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	owner.get_node("ReloadTween").start()
	pass
