tool
extends Spatial
class_name EditorBase

export var floor_edit: PackedScene
export var wall_container: PackedScene
export var wall_top: Mesh
export var wall_collision: Shape


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

func load_masonry(data: MasonryData, overwrite=true):
	if overwrite:
		for i in self.get_children():
			i.queue_free()
	
	for f in data.floor_data:
		var mesh = f[0]
		var positions = f[1]
		for p in positions:
			create_floor(mesh, p)
	
	var wall_custom_top = false
	
	if data.wall_top:
		wall_custom_top = true
	
	for w in data.wall_data:
		if wall_custom_top:
			w[1].append(data.wall_top)
		
		create_wall(w[1], w[0], wall_custom_top)


func save_masonry() -> MasonryData:
	var masonry_new := MasonryData.new()
	
	for f in self.get_children():
		if f.is_in_group("FloorEdit"):
			var position = f.transform.origin
			masonry_new.add_floor(f.variant, Vector2(position.x, position.z))
	
	masonry_new.wall_top = wall_top
	masonry_new.wall_shape = wall_collision
	
	for w in self.get_children():
		if w.is_in_group("WallContainer"):
			var position = w.transform.origin
			masonry_new.add_wall(Vector2(position.x, position.z), w.get_walls())
	
	return masonry_new


# ----- Create Utilities -----

func create_floor(variant: Mesh, position: Vector2):
	var floor_new: = floor_edit.instance()
	floor_new.transform.origin = Vector3(position.x, 0, position.y)
	floor_new.variant = variant
	self.add_child(floor_new)


func create_wall(variant: Array, position: Vector2, set_top=false):
	var wall_new: = wall_container.instance()
	wall_new.transform.origin = Vector3(position.x, 0, position.y)
	
	wall_new.left = variant[0]
	wall_new.right = variant[1]
	wall_new.front = variant[2]
	wall_new.back = variant[3]
	
	self.add_child(wall_new)
	if set_top:
		wall_new.top = variant[4]
