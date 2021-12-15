extends RigidBody;

export var layer_mask = 95;
export var health = 100;
export var break_unit_DB = 50;
export var material_type = "GLASS";

onready var impact_util = get_node("/root/Utilities/ImpactSoundSet");

func _ready():
	set_collision_mask(layer_mask);
	set_mode(MODE_KINEMATIC);
	set_contact_monitor(true);
	contacts_reported = 5;
	connect("body_entered",self, "take_damage");
	
func take_damage(body: Node):
	
	print(health);
	
	if "bullet_damage" in body:
		health -= body.bullet_damage;
		
	if health <= 0:
		destroy_brush();
	pass

func destroy_brush():
	var player: PlayThenDeletePlayer = PlayThenDeletePlayer.new();
	var random: RandomNumberGenerator = RandomNumberGenerator.new();
	get_tree().root.add_child(player);
	player.get_global_transform().origin = get_global_transform().origin;
	player.unit_db = break_unit_DB;
	player.stream = impact_util.GetSound(material_type);
	player.play();
	queue_free();
	pass
