class_name WaterAnimated
extends Spatial

var current_scale: float = 0
var water_mesh: MeshInstance

func _ready():
	water_mesh = get_child(0)


func _process(delta):
	
	if(water_mesh == null):
		water_mesh = get_child(0)
		return
	
	var mat: SpatialMaterial = water_mesh.get_active_material(0)
	
	if(mat == null):
		return
	
	current_scale += delta
	mat.normal_scale = (sin(current_scale*2)/4 + 1)
	pass
