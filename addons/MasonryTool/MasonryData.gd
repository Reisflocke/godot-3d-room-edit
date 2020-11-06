tool
extends Resource
class_name MasonryData
# holds all the data and data mangement functions for Masonrys

export var floor_data: Array
# ----- STRUCUTRE -----
# floor_array = [variant_a: Mesh, positions: PoolVector2Array], [variant_b: Mesh, positions: PoolVector2Array], [...]
export var wall_data: Array
export var wall_top: Mesh
export var wall_shape: Shape


func add_floor(mesh: Mesh, position: Vector2) -> void:
	# try to add to exsisting variant
	for i in floor_data:
		if i[0] == mesh:
			i[1].append(position) # PoolVector2Array ERROR --> need to use normal Array because PoolArray won't append
			return
	
	# create new floor variant
	var position_array: Array = [position]
	floor_data.append([mesh, position_array])


func add_wall(position: Vector2, meshes: Array) -> void:
	if meshes.size() < 4:
		print_debug("The Wall you wanne save doesn't habe 4 sides!")
		return
	
	var wall_array = [
		position,
		[meshes[0],
		meshes[1],
		meshes[2],
		meshes[3]]
	]
	
	wall_data.append(wall_array)
