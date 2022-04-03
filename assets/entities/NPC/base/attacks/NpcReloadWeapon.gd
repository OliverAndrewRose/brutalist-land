extends Node

var is_reloading: bool = false;
var reload_delay: float = 4;
var reload_timer: Timer = Timer.new();

onready var _weapon_properties: NpcWeaponProperties = get_node("../weapon_properties") as NpcWeaponProperties;

func _ready():
	self.add_child(reload_timer);
	reload_timer.connect("timeout", self, "weapon_reloaded");

# Start reloading the current weapon.
func reload_weapon():
	reload_timer.start(reload_delay);
	is_reloading = true;

# The weapon is now reloaded.
func weapon_reloaded():
	reload_timer.stop();
	is_reloading = false;
	_weapon_properties.ammo = _weapon_properties.mag_size;
