tool
extends StaticBody
class_name CollisionGenerator


func generate_shapes(positions: PoolVector2Array, shape: Shape):
	if shape == null:
		print_debug("Can't generate. Shape == null!")
		return
	
	for i in positions:
		var collision_new := CollisionShape.new()
		collision_new.shape = shape
		collision_new.transform.origin = Vector3(i.x, 0.0, i.y)
		self.add_child(collision_new)
		collision_new.set_owner(get_tree().edited_scene_root)
