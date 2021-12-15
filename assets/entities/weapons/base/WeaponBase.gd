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

func fire_weapon() -> void:
	pass
