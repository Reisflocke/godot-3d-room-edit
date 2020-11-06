tool
extends Spatial
# The Base for the RoomEditor

signal rooms_changed(rooms, current_room)

export var room_container: PackedScene
export var tile_edit: PackedScene

var current_room: Spatial setget set_current_room


# ----- Input Utilities -----

static func get_click_collision(camera: Camera, screen_point: Vector2) -> Dictionary:
	var from := camera.project_ray_origin(screen_point)
	var to := from + camera.project_ray_normal(screen_point) * camera.far
	var space_state = camera.get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 2)
	return result


static func get_click_hit_ground(camera: Camera, screen_point: Vector2):
	var origin: Vector3 = camera.project_ray_origin(screen_point)
	var distance: float = camera.far
	var normal: Vector3 = camera.project_ray_normal(screen_point)
	var destination: Vector3 = origin + (normal*distance)#camera.project_position(screen_point, distance)
	
	var intersection_point = null
	
	if destination.y <= 0 and origin.y > 0: # check if looking from up to down
		var scalar: float = 1.0 - (abs(destination.y)/(origin.y+abs(destination.y)))
		intersection_point = origin + (normal*(distance*scalar))
	
	return intersection_point


func get_input_origin(input_position: Vector3) -> Vector3:
	var global_origin := self.global_transform.origin
	return Vector3(
		input_position.x - global_origin.x,
		0,
		input_position.z - global_origin.z).round()


# ----- Load/Save Utilities -----

func load_rooms(data: Array, overwrite=true):
	if overwrite:
		for i in self.get_children():
			i.name = "QueudForDeletion"
			i.queue_free()
	
	for r in data:
		var room_new := add_room()
		for t in r:
			create_tile(room_new, t)
		room_new.active = false


func save_rooms() -> Array:
	var rooms_new: Array = []
	
	for r in self.get_children():
		var tile_data: PoolVector3Array
		for t in r.get_children():
			var tile_position: Vector3 = t.transform.origin
			tile_data.append(tile_position)
		rooms_new.append(tile_data)
	
	return rooms_new


# ----- Create Utilities -----

func create_tile(room: Spatial, position: Vector3):
	if not room:
		print_debug("Can't create tile. Room isn't set.")
		return
	
	var tile_new: = tile_edit.instance()
	tile_new.transform.origin = position
	room.add_child(tile_new)


# ----- RoomManger -----

func add_room() -> Spatial:
	var room_new: Spatial = room_container.instance()
	room_new.name = "Room"
	self.add_child(room_new)
	emit_signal("rooms_changed", self.get_children(), current_room)
	return room_new


func remove_room(room: Spatial = current_room) -> void:
	if room == current_room:
		current_room = null
	if not room:
		return
	room.queue_free()
	var children: Array = []
	for c in self.get_children():
		if not c.is_queued_for_deletion():
			children.append(c)
	emit_signal("rooms_changed", children, current_room)


# ----- SETGET -----

func set_current_room(value):
	current_room = value
	for i in self.get_children():
		if i.is_in_group("RoomContainer"):
			i.active = false
	if current_room:
		current_room.active = true
