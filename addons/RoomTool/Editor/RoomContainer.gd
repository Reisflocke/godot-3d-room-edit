tool
extends Spatial

var active: bool = false setget set_active


func set_active(value):
	active = value
	for i in self.get_children():
		if i.is_in_group("TileEdit"):
			i.active = active
