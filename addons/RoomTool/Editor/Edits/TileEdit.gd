tool
extends StaticBody

export var active: bool = false setget set_active

func set_active(value):
	active = value
	$MeshInstance.get_surface_material(0).set_shader_param("active", active)
