extends Node2D

onready var player = owner
var movement_speed = 0.0
var recoil = 0.0;

func _ready():
	position = get_viewport().size / 2
	get_tree().connect("screen_resized", self, "_on_screen_resized")

func _process(delta):
	movement_speed = player.movement.length()
	$Line1.position.x = clamp(-7 + (recoil * -1.6), -40, -7)
	$Line2.position.y = clamp(-7 + (recoil * -1.6), -40, -7)
	$Line3.position.x = clamp(7 + (recoil * 1.6), 7, 40)
	$Line4.position.y = clamp(7 + (recoil * 1.6), 7, 40)

func _on_screen_resized():
	position = get_viewport().size / 2
