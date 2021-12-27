extends RayCast

var can_use = true
var text_visible = false
var default_text = "Interact"
onready var player: Spatial = owner as Spatial;
var _modulate_color: Color;

func _ready():
	_modulate_color = $InteractText.modulate;
	$InteractText.modulate = Color(0.81, 0.5, 0.09, 0)

func _physics_process(delta):
	
	if get_collider() != null and get_collider().has_method("receive_interaction"):
		if "interact_text" in get_collider():
			interact_text_appears(get_collider().interact_text);
		else:
			interact_text_appears(default_text);
	else:
		interact_text_disappears()
	
	if get_collider() != null:
		if Input.is_key_pressed(KEY_E) and get_collider().has_method("receive_interaction"):
			if can_use:
				can_use = false
				get_collider().receive_interaction(player);
				
		else:
			can_use = true
		pass

func interact_text_appears(text: String):
	if not text_visible:
		text_visible = true
		var animation_speed = 0.25
		$InteractTween.interpolate_property($InteractText, "margin_top", 90, 80, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.interpolate_property($InteractText, "modulate", Color(0.81, 0.5, 0.09, 0), _modulate_color, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractText.text = text;
		$InteractTween.start()

func interact_text_disappears():
	if text_visible:
		text_visible = false
		var animation_speed = 0.25
		$InteractTween.interpolate_property($InteractText, "margin_top", 80, 90, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.interpolate_property($InteractText, "modulate", _modulate_color, Color(0.81, 0.5, 0.09, 0), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.start()
		$TextTimer.start()
