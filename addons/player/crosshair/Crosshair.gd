extends Node2D

onready var player = owner
var movement_speed = 0.0

func _ready():
	position = get_viewport().size / 2
	get_tree().connect("screen_resized", self, "_on_screen_resized")

func _process(delta):
	movement_speed = player.movement.length()
	$Line1.position.x = clamp(-7 + (movement_speed * -1.6), -21, -7)
	$Line2.position.y = clamp(-7 + (movement_speed * -1.6), -21, -7)
	$Line3.position.x = clamp(7 + (movement_speed * 1.6), 7, 21)
	$Line4.position.y = clamp(7 + (movement_speed * 1.6), 7, 21)

func _on_screen_resized():
	position = get_viewport().size / 2
