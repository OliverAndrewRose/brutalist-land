extends Node

onready var health: Health = get_node("../../Health") as Health;
export(float) var head_multiplier: float = 4.0;
export(float) var body_mutliplier: float = 1.0;
export(float) var limb_multiplier: float  = 0.75;


func _process_damage(bullet: Bullet, bodypart_path: String, multiplier: float):
	
	if bullet != null:
		var hit_force_dir: Vector3 = -bullet.get_global_transform().basis.z * bullet.bullet_force;
		health.take_damage_and_force(bullet.bullet_damage * multiplier, bodypart_path, hit_force_dir);


func _on_col_head_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/Head");
	_process_damage(body, bodypart, head_multiplier);


func _on_col_spine2_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/Spine2");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_spine_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/Spine2");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_rightupleg_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/RightUpLeg");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_leftupleg_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/LeftUpLeg");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_rightleg_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/RightLeg");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_leftleg_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/LeftLeg");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_leftarm_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/LeftArm");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_leftforearm_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/LeftForeArm");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_rightarm_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/RightArm");
	_process_damage(body, bodypart, body_mutliplier);


func _on_col_rightforearm_body_entered(body):
	var bodypart: String = ("Armature/Skeleton/RightForeArm");
	_process_damage(body, bodypart, body_mutliplier);
