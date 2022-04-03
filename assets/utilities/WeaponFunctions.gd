extends Node
class_name WeaponFunctions

const bullet_dust_scene: PackedScene = preload("res://assets/entities/weapons/bullet/bullet_dust.tscn");

# Fires a bullet. Used by the player and NPCs.
static func scan_bullet_hit(hit_scan: RayCast, damage: float, force_magnitude: float):
	
	# Gets the hit entity.
	var _hit_entity = hit_scan.get_collider();
	
	if _hit_entity == null or !weakref(_hit_entity).get_ref():
		return
	
	if "weight" in _hit_entity:
		# Add damage and a force to object based on the ray cast's direction.
		_hit_entity.apply_central_impulse(force_magnitude * -hit_scan.global_transform.basis.z);
		if(_hit_entity.has_method("process_damage")):
			_hit_entity.process_damage(damage, -hit_scan.global_transform.basis.z * damage);
			create_bullet_impact(hit_scan, false);
		else:
			create_bullet_impact(hit_scan, true);
	else:
		create_bullet_impact(hit_scan, true);


# Generates a bullet impact effect using the given raycast.
static func create_bullet_impact(hit_scan: RayCast, is_dust_effect_active: bool):
	var _impact: Spatial = bullet_dust_scene.instance()
	hit_scan.get_tree().get_root().add_child(_impact);
	
	_impact.global_transform.origin = hit_scan.get_collision_point();
	_impact.look_at(hit_scan.get_collision_point() - hit_scan.get_collision_normal(), Vector3.UP);
	
	if is_dust_effect_active:
		_impact.get_node("Particles").emitting = true;
