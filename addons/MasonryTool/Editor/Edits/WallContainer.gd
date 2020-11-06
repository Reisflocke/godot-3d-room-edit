tool
extends Spatial

export var left: Mesh setget set_left, get_left
export var right: Mesh setget set_right, get_right
export var front: Mesh setget set_front, get_front
export var back: Mesh setget set_back, get_back
export var top: Mesh setget set_top, get_top


func get_walls() -> Array:
	return [
		get_left(), get_right(), get_front(), get_back()
	]


func set_left(value: Mesh) -> void:
	$Left.variant = value
	left = value


func get_left() -> Mesh:
	left = $Left.variant
	return left


func set_right(value: Mesh) -> void:
	$Right.variant = value
	right = value


func get_right() -> Mesh:
	right = $Right.variant
	return right


func set_front(value: Mesh) -> void:
	$Front.variant = value
	front = value


func get_front() -> Mesh:
	front = $Front.variant
	return front


func set_back(value: Mesh) -> void:
	$Back.variant = value
	back = value


func get_back() -> Mesh:
	back = $Back.variant
	return back


func set_top(value: Mesh) -> void:
	if not self.is_inside_tree():
		return
	
	$Top.mesh = value
	top = value


func get_top() -> Mesh:
	if not self.is_inside_tree():
		return null
	
	top = $Top.mesh
	return top
