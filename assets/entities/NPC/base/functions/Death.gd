extends Node
class_name Death

export(PackedScene) var body_ragdoll;
export(float) var ragdoll_movement_force_multiplier = 6;
onready var _animator: AnimationPlayer = owner.get_node("model").get_node("AnimationPlayer");
onready var _animator_tree: AnimationTree = _animator.get_node("../AnimationTree");
var _ragdoll: Spatial;
var _rag_skeleton: Skeleton;

func _on_Health_character_death(bodypart_path: String, force: Vector3):
	
	if bodypart_path != null and force != null:
		ragdoll_character_with_force(bodypart_path, force);
	else:
		ragdoll_character();
	
	owner.queue_free();


func ragdoll_character_with_force(bodypart_path: String, force: Vector3):
	ragdoll_character();
	_ragdoll.get_node(bodypart_path).apply_central_impulse(force);
	_add_movement_force();
	

func ragdoll_character():
	_ragdoll = body_ragdoll.instance();
	get_tree().get_root().add_child(_ragdoll);
	_set_ragdoll_animations();
	
	_ragdoll.global_transform = owner.get_node("model").global_transform;
	_rag_skeleton = _ragdoll.get_node("Armature").get_node("Skeleton");
	_rag_skeleton.physical_bones_start_simulation();

func _set_ragdoll_animations():
	var ragdoll_animator: AnimationPlayer = _ragdoll.get_node("AnimationPlayer");
	var ragdoll_animator_tree: AnimationTree = ragdoll_animator.get_node("../AnimationTree");
	
	ragdoll_animator_tree = _animator_tree;
	ragdoll_animator = _animator;
	ragdoll_animator_tree.active
	pass
	
# Adds the NPC's current movement force to the _ragdoll
func _add_movement_force():
	var force: Vector3 = (owner as NPCProperties).linear_velocity;
	
	# Apply force to all physical bones in _ragdoll.
	for child in _rag_skeleton.get_children():
		if child.is_class("PhysicalBone"):
			child.apply_central_impulse(force*ragdoll_movement_force_multiplier);
	pass
