extends WeaponBase
class_name WeaponGrapple

onready var player: Player = owner.owner as Player;
var anim_player: AnimationPlayer 
export(PackedScene) var harpoon_scene: PackedScene;
export(PackedScene) var rope_scene: PackedScene;
export(int) var harpoon_fire_velocity = 100;
export(float) var grapple_speed_multiplier = 110;

onready var _initial_grav = player.gravity;
var _harpoon: RigidBody;
var _rope: HarpoonRope;
var _grapple_active = false;

# Fires the harpoon.
func fire_weapon():
	.fire_weapon();
	_fire_harpoon();
	_create_rope();
	pass
	
# Alternative fire for the weapon.
func alt_fire_weapon():
	
	# If the rope does not exist, they can't grapple.
	if not _rope and not weakref(_rope).get_ref():
		return;
	
	if not _harpoon.is_hooked():
		return;
	
	# This toggles the grapple ability of the harpoon gun.
	if _grapple_active:
		_grapple_active = false
		_destroy_rope();
	else:
		_grapple_active = true;
	pass

# Plays the reload animation. Also destroys the rope if it's active.
func process_reload():
	.process_reload();
	
	if _grapple_active:
		_grapple_active = false;
	
	if _rope and weakref(_rope).get_ref():
		_destroy_rope();
	pass
	
	
func play_reload_animation():
	.play_reload_animation();
	anim_player = owner.current_weapon_model.get_node("AnimationPlayer");
	anim_player.play("reload_regular");


func _fire_harpoon():
	_harpoon = harpoon_scene.instance();
	get_tree().get_root().get_node("Root").add_child(_harpoon);
	_harpoon.global_transform = owner.get_node("Position3D/LookAt/ShootPosition").get_global_transform();
	_harpoon.apply_impulse(Vector3.ZERO, -owner.get_node("Position3D/LookAt/ShootPosition").get_global_transform().basis.z * harpoon_fire_velocity);

# Creates a visual rope to the harpoon.
func _create_rope():
	_rope = rope_scene.instance() as HarpoonRope;
	get_tree().get_root().get_node("Root").add_child(_rope);
	_rope.start_body = owner.current_weapon_model.get_node("RopeStart");
	_rope.end_body = _harpoon;
	pass


func _process(_delta):
	if Input.is_action_just_pressed("Alt Fire"):
		alt_fire_weapon();
	if Input.is_action_just_released("Alt Fire"):
		alt_fire_weapon();
	pass


func _physics_process(delta):
	if _grapple_active:
		_force_to_harpoon(delta);

# The grapple ability forces the player towards the harpoon.
func _force_to_harpoon(delta: float):
	var _movement = (_harpoon.global_transform.origin - player.global_transform.origin).normalized() * delta * grapple_speed_multiplier;
	
	if player.velocity.length() > grapple_speed_multiplier:
		return;
		
	player.velocity = player.velocity + _movement;
	pass


func _destroy_rope():
	_rope.queue_free();
	_rope = null
	pass
