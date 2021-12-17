extends WeaponBase
class_name WeaponGrapple
var anim_player: AnimationPlayer

func fire_weapon():
	.fire_weapon();
	pass
	
func play_reload_animation():
	.play_reload_animation();
	anim_player = owner.current_weapon_model.get_node("AnimationPlayer") as AnimationPlayer;
	anim_player.play("RESET");
