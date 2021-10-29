extends Node

export var skeleton := NodePath();
onready var skeleton_node: Skeleton = get_node(skeleton) as Skeleton;


func ragdoll_character():
	skeleton_node.physical_bones_start_simulation();
	pass


func _on_Health_character_death():
	owner.queue_free();
	#ragdoll_character();
