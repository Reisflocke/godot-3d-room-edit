tool
extends StaticBody

export var variant: Mesh setget set_variant


func set_variant(value: Mesh) -> void:
	if not self.is_inside_tree():
		yield(self, "tree_entered")
	
	variant = value
	$MeshInstance.mesh = variant


func get_variant() -> Mesh:
	if not self.is_inside_tree():
		yield(self, "tree_entered")
	
	variant = $MeshInstance.mesh
	return variant
