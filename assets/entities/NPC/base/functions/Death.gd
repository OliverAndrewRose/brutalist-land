extends Node

export(PackedScene) var body_ragdoll;
onready var animator: AnimationPlayer = owner.get_node("model").get_node("AnimationPlayer");


func ragdoll_character():
	var ragdoll: Spatial = body_ragdoll.instance();
	get_tree().get_root().add_child(ragdoll);
	ragdoll.global_transform = owner.get_node("model").global_transform;
	print(ragdoll.get_global_transform().origin);
	ragdoll.get_node("AnimationPlayer").current_animation = animator.current_animation;
	ragdoll.get_node("Armature").get_node("Skeleton").physical_bones_start_simulation();

func _on_Health_character_death():
	ragdoll_character();
	owner.queue_free();
