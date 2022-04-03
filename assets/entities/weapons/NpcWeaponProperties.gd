extends Node
class_name NpcWeaponProperties

export(String) var weapon_name: String;
export(PackedScene) var weapon_model: PackedScene;
export(int) var mag_size: int = 15; 
export(int) var damage: int = 20;
export(float) var hit_force: float = 100.0
export(int) var ammo: int = 15;


export(float) var max_range: float = 100.0;
export(float) var max_fire_rate: float = 5.0; # Bullets per second.
export(float) var min_fire_rate: float = max_fire_rate / 1.5; # Bullets per second.
export(bool) var single_fire: bool = true;


# Called when the node enters the scene tree for the first time.
func _ready():
	
	clamp(ammo, 0, mag_size);
	
	if not single_fire:
		min_fire_rate = max_fire_rate;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
