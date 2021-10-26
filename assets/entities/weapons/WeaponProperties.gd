extends Node
class_name WeaponProperties

export(String) var weapon_name: String;
export(int) var mag_size: int = 20; 
export(int) var damage: int = 20;
export(float) var fire_rate: float = 2.0; # Bullets per second.
export(float) var bullet_velocity: float = 0.5;
export(String) var bullet_directory;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
