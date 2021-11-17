extends Spatial

export(PackedScene) var spawn_entity: PackedScene;
var _entity: Spatial;

# Called when the node enters the scene tree for the first time.

func _process(delta):
	
	# Checks if the entity is dead or deleted.
	if _entity == null or !weakref(_entity).get_ref():
		_spawn_entity();
	pass


func _spawn_entity():
	_entity = spawn_entity.instance();
	get_tree().get_root().add_child(_entity);
	_entity.global_transform = get_global_transform(); 
	pass
