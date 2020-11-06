tool
extends Spatial
class_name RoomConnector, "res://addons/RoomTool/room_connector_icon.png"

export var wall_a: Mesh setget set_wall_a
export var wall_b: Mesh setget set_wall_b


func set_wall_a(value):
	if not self.is_inside_tree():
		yield(self, "tree_entered")
	
	wall_a = value
	$WallA.variant = wall_a


func set_wall_b(value):
	if not self.is_inside_tree():
		yield(self, "tree_entered")
	
	wall_b = value
	$WallB.variant = wall_b


