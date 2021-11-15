extends Node

export(PackedScene) var body_ragdoll;
onready var animator: AnimationPlayer = owner.get_node("model").get_node("AnimationPlayer");
var ragdoll: Spatial = null;

func ragdoll_character():
	ragdoll = body_ragdoll.instance();
	get_tree().get_root().add_child(ragdoll);
	ragdoll.global_transform = owner.get_node("model").global_transform;
	print(ragdoll.get_global_transform().origin);
	ragdoll.get_node("AnimationPlayer").current_animation = animator.current_animation;
	ragdoll.get_node("Armature").get_node("Skeleton").physical_bones_start_simulation();
	

func ragdoll_character_with_force(bodypart_path: String, force: Vector3):
	ragdoll_character();
	ragdoll.get_node(bodypart_path).apply_central_impulse(force);
	

func _on_Health_character_death(bodypart_path: String, force: Vector3):
	
	if bodypart_path != null and force != null:
		ragdoll_character_with_force(bodypart_path, force);
	else:
		ragdoll_character();

	owner.queue_free();
