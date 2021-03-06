extends Spatial
class_name Shoot

var current_weapon: WeaponBase;
var current_weapon_model: Spatial;
var current_weapon_index: int = 0;
var hand_index: int = 0;
export(Array, NodePath) var available_weapons: Array;


var weapon_sway_amount = 5
var mouse_relative_x = 0
var mouse_relative_y = 0

var enable_all_input = true;
var can_shoot = true
var weapon_position_z = -0.2

var can_switch_joy_dpad = true
var reload_tip_displayed = false
onready var weapon = $Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon

onready var player = owner
onready var camera = player.get_node("Head/Camera")
onready var crosshair = player.get_node("Head/Camera/Crosshair")
var recoil: float;

# Sound detection effect.
onready var sound_detection_timer: Timer = Timer.new();
var sound_detection_fade_time: float = 0.5;

signal on_weapon_swap(player_weapon)

func _ready():
	add_child(sound_detection_timer);
	sound_detection_timer.connect("timeout",self,"deactivate_sound_trigger");
	deactivate_sound_trigger();
	switch_weapon();
	pass


func _input(event):
	
	if not enable_all_input:
		return;
	
#	Getting the mouse movement for the weapon sway in the physics process
	if event is InputEventMouseMotion:
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
		
	if Input.is_action_pressed("holster weapon"):
		current_weapon_index = hand_index;
		switch_weapon();
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_DOWN:
				if not $ReloadTween.is_active():
					current_weapon_index += 1
					switch_weapon()
			if event.button_index == BUTTON_WHEEL_UP:
				if not $ReloadTween.is_active():
					current_weapon_index -= 1
					switch_weapon()


func _process(delta):
	
	if not enable_all_input:
		return;
	
	if Input.is_action_pressed("fire"):
		if $FireRateTimer.is_stopped() and can_shoot:
			if current_weapon.current_ammo > 0:
				shoot()
				$FireRateTimer.start()
			else:
				$FireRateTimer.start()
				
			if current_weapon.current_ammo <= current_weapon.max_ammo / 6:
				ammo_animation()
	
	weapon_look_animation(delta);
	
	if not current_weapon.hide_ammo_hud:
		reload_tip()
	
	crosshair.recoil = crosshair.recoil + (recoil*10 - crosshair.recoil) * delta * 2;
	
	if current_weapon.single_shot:
		if Input.is_action_pressed("fire"):
			can_shoot = false
		else:
			can_shoot = true

	_process_reload();


func shoot():
	# Adding echo
	_play_gun_sound();
	activate_sound_trigger();
	
	# Calculate bullet spread amount
	_process_recoil();
	current_weapon.fire_weapon();
	
	current_weapon.current_ammo -= 1
	
	if not current_weapon.hide_ammo_hud:
		$HUD/DisplayAmmo/AmmoText.text = str(current_weapon.current_ammo)


func _process_reload():
	if Input.is_action_just_pressed("reload"):
		if current_weapon.current_ammo != current_weapon.max_ammo and current_weapon.total_ammo > 0:
			current_weapon.process_reload();
			play_sound(current_weapon.reload_sound, -5, 0)
			
			if $HUD/ReloadTip.modulate == Color(1, 1, 1, 1):
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "margin_top", 35, 45, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				reload_tip_displayed = false


func _play_gun_sound():
	var delay = 0
	var dB = -5
	play_sound(current_weapon.shoot_sound, dB, delay)
	pass


func _process_recoil():
	recoil = 0
	if($RecoilTimer.time_left == 0):
		recoil = $RecoilTimer.wait_time * current_weapon.bullet_spread * (1 + player.player_speed / 10) * 0.1;
	else:
		recoil = $RecoilTimer.time_left * current_weapon.bullet_spread* (1 + player.player_speed / 10)
	
	$BulletSpread.rotation_degrees.z = rand_range(0, 360)
	$BulletSpread/RayCast.rotation_degrees.y = rand_range(-recoil, recoil)
	
	$RecoilTimer.start()
	pass

	
func play_sound(sound, dB, delay):
	var audio_node = AudioStreamPlayer.new()
	audio_node.stream = sound
	audio_node.volume_db = dB
	audio_node.pitch_scale = rand_range(0.95, 1.05)
	get_tree().get_root().add_child(audio_node)
	yield(get_tree().create_timer(delay), "timeout")
	audio_node.play()
	yield(get_tree().create_timer(10.0), "timeout")
	audio_node.queue_free()


func calculate_ammo():
	var difference = current_weapon.max_ammo - current_weapon.current_ammo;
	# If we have more ammo missing than in the clip, take all the ammo in the clip remaining
	if difference > current_weapon.total_ammo:
		current_weapon.current_ammo += current_weapon.total_ammo;
		current_weapon.total_ammo = 0;
	else:
		current_weapon.total_ammo -= difference;
		current_weapon.current_ammo = current_weapon.max_ammo;
	
	update_ammo_HUD()


func switch_weapon():
	
	if(current_weapon_model):
		current_weapon_model.queue_free();
	
	
	current_weapon = get_node(available_weapons[current_weapon_index % available_weapons.size()]) as WeaponBase;
	current_weapon_model = (current_weapon.weapon_model as PackedScene).instance();
	$Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway/Weapon.add_child(current_weapon_model);
	current_weapon_model.get_transform().origin = Vector3.ZERO;
	weapon_position_z = current_weapon.weapon_z_position;
	
	$FireRateTimer.wait_time = 1 / current_weapon.fire_rate;
	
	ammo_animation()
	
	var background_color_active = Color(0, 0, 0, 0.25)
	var background_color_inactive = Color(0, 0, 0, 0.1)
	
	var text_color_active = Color(1, 1, 1, 1)
	var text_color_inactive = Color(1, 1, 1, 0.5)
	
	update_ammo_HUD()
	
	$HUD/WeaponSelected/Weapon1.text = current_weapon.weapon_name;
	$SwitchWeaponTween.interpolate_property($Position3D/SwitchAndAttack, "translation", Vector3(0, -0.25, -0.1), Vector3(), 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$SwitchWeaponTween.interpolate_property($Position3D/SwitchAndAttack, "rotation_degrees", Vector3(-30, 20, 10), Vector3(), 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$SwitchWeaponTween.start()
	
	emit_signal("on_weapon_swap", current_weapon);


func _on_RecoilTimer_timeout():
	$BulletSpread/RayCast.rotation_degrees = Vector3()
	recoil = 0;


func _on_ReloadTween_tween_all_completed():
	calculate_ammo()
	ammo_animation()


func weapon_look_animation(delta: float):
	
	if $BulletSpread/RayCast.is_colliding():
		$Position3D/LookAt.look_at($BulletSpread/RayCast.get_collision_point(), Vector3.UP)
		$Position3D/SwitchAndAttack/Bobbing/LookAtLerp.rotation_degrees = lerp($Position3D/SwitchAndAttack/Bobbing/LookAtLerp.rotation_degrees, $Position3D/LookAt.rotation_degrees, 10 * delta)
	else:
		$Position3D/LookAt.rotation_degrees = Vector3()
		$Position3D/SwitchAndAttack/Bobbing/LookAtLerp.rotation_degrees = lerp($Position3D/SwitchAndAttack/Bobbing/LookAtLerp.rotation_degrees, $Position3D/LookAt.rotation_degrees, 10 * delta)
	
	$Position3D/SwitchAndAttack/Bobbing/LookAtLerp.rotation_degrees.z = 0
	
#	Weapon sway
	$Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.z = lerp($Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.z, -mouse_relative_x / 10, weapon_sway_amount * delta)
	$Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.y = lerp($Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.y, mouse_relative_x / 20, weapon_sway_amount * delta)
	$Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.x = lerp($Position3D/SwitchAndAttack/Bobbing/LookAtLerp/Sway.rotation_degrees.x, -mouse_relative_y / 10, weapon_sway_amount * delta)
	
	var weapon_movement = clamp(player.player_speed * 0.003, 0, 0.018)
	
	
	if round(player.player_speed) == 0:
		$Position3D.translation.y = lerp($Position3D.translation.y, -0.1, 5 * delta)
		$Position3D.translation.z = lerp($Position3D.translation.z, weapon_position_z, 5 * delta)
	else:
		$Position3D.translation.y = lerp($Position3D.translation.y, -0.1 + -weapon_movement, 5 * delta)
		$Position3D.translation.z = lerp($Position3D.translation.z, weapon_position_z + weapon_movement, 5 * delta)
		
		if player.player_speed >= 3:
			weapon_bobbing_animation()
	
	if $ReloadTween.is_active() or $SwitchWeaponTween.is_active():
		return


func weapon_bobbing_animation():
	var animation_speed = 0.5
	var animation_value = 0.01 * player.player_speed; # 0.01
	
	if not $HBobbingTween.is_active():
		$HBobbingTween.interpolate_property($Position3D/SwitchAndAttack/Bobbing, "translation:x", 0, animation_value, animation_speed*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$HBobbingTween.interpolate_property($Position3D/SwitchAndAttack/Bobbing, "translation:x", animation_value, 0, animation_speed*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, animation_speed*2)
		$HBobbingTween.start()
	
	if not $VBobbingTween.is_active():
		$VBobbingTween.interpolate_property($Position3D/SwitchAndAttack/Bobbing, "translation:y", animation_value / 4, 0, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$VBobbingTween.interpolate_property($Position3D/SwitchAndAttack/Bobbing, "translation:y", 0, animation_value / 4, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT, animation_speed)
		$VBobbingTween.start()


func ammo_animation():
	var animation_speed = 0.1
	
	$InterfaceTween.interpolate_property($HUD/AmmoText, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), animation_speed, Tween.TRANS_SINE)
	$InterfaceTween.interpolate_property($HUD/DisplayAmmo/AmmoText, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), animation_speed, Tween.TRANS_SINE)
	$InterfaceTween.interpolate_property($HUD/DisplayAmmo/Slash, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), animation_speed, Tween.TRANS_SINE)
	$InterfaceTween.interpolate_property($HUD/DisplayAmmo/ClipText, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 1), animation_speed, Tween.TRANS_SINE)
	$InterfaceTween.start()


func update_ammo_HUD():
	
	if(current_weapon.hide_ammo_hud):
		$HUD/DisplayAmmo/AmmoText.text = "-"
		$HUD/DisplayAmmo/ClipText.text = "-"
	else:
		$HUD/DisplayAmmo/AmmoText.text = str(current_weapon.current_ammo);
		$HUD/DisplayAmmo/ClipText.text = str(current_weapon.total_ammo);


func reload_tip():
	if current_weapon.total_ammo > 0:
		$HUD/ReloadTip.text = "Reload"
	else:
		$HUD/ReloadTip.text = "Out of ammo"
	
	var animation_speed = 0.25
	
	if current_weapon.current_ammo == 0:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if reload_tip_displayed == false:
				$ReloadTipTween.stop_all()
				
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "margin_top", 45, 35, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), animation_speed, Tween.TRANS_SINE)
				reload_tip_displayed = true
		else:
			if reload_tip_displayed:
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "margin_top", 35, 45, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT, animation_speed)
				$ReloadTipTween.interpolate_property($HUD/ReloadTip, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT, animation_speed)
				reload_tip_displayed = false
	
	$ReloadTipTween.start()


# This activates the collision sphere so enemies
# can detect the sound from the shot.
func activate_sound_trigger():
	$SoundDetection.scale = Vector3.ONE * current_weapon.max_sound_distance;
	$SoundDetection/CollisionShape.disabled = false;
	sound_detection_timer.start(sound_detection_fade_time);

func deactivate_sound_trigger():
	$SoundDetection.scale = Vector3.ONE * 0.01;
	$SoundDetection/CollisionShape.disabled = true;
	sound_detection_timer.stop();

func set_active_input(set_active: bool):
	enable_all_input = set_active;
