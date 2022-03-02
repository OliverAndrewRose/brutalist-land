extends RigidBody;

export(Dictionary) var properties setget set_properties

export var col_mask = 559;
export var col_layer = 512;
export var health = 40;
export var break_unit_DB = 80;
export var max_sound_distance = 50;
export var material_type = "GLASS";

onready var impact_util = get_node("/root/ImpactSoundSet");

func _ready():
	set_collision_mask(col_mask);
	set_collision_layer(col_layer);
	set_mode(MODE_KINEMATIC);
	set_contact_monitor(true);
	contacts_reported = 5;
	connect("body_entered",self, "take_damage");
	
	
func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()
	
	
func update_properties():
	if "health" in properties:
		self.health = properties.health;
	
	if "material_type" in properties:
		self.material_type = properties.material_type;
	pass

	
func take_damage(body: Node):

	
	if "bullet_damage" in body:
		health -= body.bullet_damage;
		
	if health <= 0:
		destroy_brush();
	pass

func destroy_brush():
	var player: PlayThenDeletePlayer = PlayThenDeletePlayer.new();
	get_tree().root.add_child(player);
	player.global_transform = self.global_transform;
	player.unit_db = break_unit_DB;
	player.max_distance = max_sound_distance;
	player.stream = impact_util.get_sound(material_type);
	player.play();
	queue_free();
	pass



