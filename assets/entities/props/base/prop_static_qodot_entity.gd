extends QodotEntity;
class_name QodotPropStatic
tool

var model_dir: String = "res://assets/entities/props/furniture/sofa_01.tscn";
var _prop_builder: BuildStaticProps;

func _ready():
	_prop_builder = get_node("../../QodotHelper/StaticPropBuilder") as BuildStaticProps;
	if not _prop_builder.registered_props.has(self):
		_prop_builder.registered_props.append(self);
	pass

func update_properties():
	
	if "model_dir" in properties:
		model_dir = properties.model_dir;
