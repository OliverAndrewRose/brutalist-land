extends Node
class_name BuildStaticProps
tool

var registered_props: Array = [];

func build_static_props() -> void:
	print("Building static props...");
	remove_old_props();
	for prop in registered_props:
		generate_model(prop);
		pass
	print("Finished building static props.")

func generate_model(static_prop):
	var _model: Spatial = load(static_prop.model_dir).instance() as Spatial;
	var _static_body = StaticBody.new();
	
	static_prop.owner = get_tree().edited_scene_root;
	static_prop.add_child(_static_body);
	_static_body.owner = get_tree().edited_scene_root;
	_static_body.transform.origin = Vector3(0,0,0);
	_static_body.collision_mask = _model.collision_mask;
		
	for _child in _model.get_children():
		_model.remove_child(_child);
		_static_body.add_child(_child);
		_child.owner = get_tree().edited_scene_root;
	
	_model.queue_free(); # Deletes the dynamic model.
	(_static_body.get_node("Model") as MeshInstance).use_in_baked_light = true;
	pass

func remove_old_props() -> void:
	for prop in registered_props:
		if prop == null or not weakref(prop).get_ref():
			registered_props.erase(prop);
	pass
