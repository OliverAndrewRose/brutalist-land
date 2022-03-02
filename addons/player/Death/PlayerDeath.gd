extends Node

export(PackedScene) var body_scene: PackedScene;
var _body: RigidBody;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Health_character_death(bodypart_path, force):
	_create_body();
	owner.queue_free();


func _create_body():
	_body = body_scene.instance() as RigidBody;
	get_tree().get_root().get_node("Root").add_child(_body);
	_body.get_node("Camera").current = true;
	_body.global_transform = owner.global_transform;
