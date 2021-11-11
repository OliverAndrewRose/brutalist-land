extends Spatial

export(PackedScene) onready var bullet_dust_scene: PackedScene;
onready var bullet: Bullet = owner as Bullet;

var impacted: bool;
var impact_transform: Transform;
var impact_normal: Vector3;
var scale_modifier: float = 2.0;

func _on_Bullet_body_entered(body):
	_process_impact(body as Spatial);


func _process_impact(body: Spatial):
	
	impact_transform = owner.get_global_transform();
	
	if not body.is_in_group("damagable") and not impacted:
		var dust: Spatial = bullet_dust_scene.instance()
		get_tree().get_root().add_child(dust);
		
		dust.global_transform = impact_transform;
		dust.scale = Vector3.ONE * scale_modifier;
		
		dust.get_node("Particles").emitting = true;
		impacted = true;
		#print("DUST SURFACE: %s" % body.name);
	pass
