tool
extends StaticBody

var variant: Mesh setget set_variant


func set_variant(value: Mesh) -> void:
	variant = value
	$MeshInstance.mesh = variant


func get_variant() -> Mesh:
	variant = $MeshInstance.mesh
	return variant
