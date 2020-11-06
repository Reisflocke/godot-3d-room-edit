tool
extends Spatial
class_name MasonryGenerator

enum Wall{LEFT, RIGHT, FRONT, BACK}

var nav_mesh: ArrayMesh = load("res://addons/MasonryTool/Generator/nav_mesh.obj")


func generate_masonry(data: MasonryData) -> void:
	if not Engine.is_editor_hint():
		print_debug("MasonryGenerator: isn't designed to work in the game.")
		return
	
	# clean up recently generated geometry
	for i in self.get_children():
		i.name = "QueudForDeletion"
		i.queue_free()
	
	# generate floors
	for i in data.floor_data:
		add_multi_mesh_maker(i[0], i[1])
	# generate walls
	var mesh_packages: Array = []
	var transform_packages = []
	
	for i in data.wall_data:
		var wall_position: Vector2 = i[0]
		var meshes: Array = i[1]
		for m in meshes.size():
			if not mesh_packages.has(meshes[m]):
				mesh_packages.append(meshes[m])
				transform_packages.append([])
			
			var index = mesh_packages.find(meshes[m])
			var m_transform: Transform
			var m_origin: Vector3 = Vector3(wall_position.x, 0, wall_position.y)
			
			match m:
				Wall.LEFT:
					m_transform = m_transform.rotated(Vector3.UP, deg2rad(-90))
					m_transform.origin = m_origin + Vector3.LEFT*0.5
				Wall.RIGHT:
					m_transform = m_transform.rotated(Vector3.UP, deg2rad(90))
					m_transform.origin = m_origin + Vector3.RIGHT*0.5
				Wall.FRONT:
					m_transform.origin = m_origin + Vector3.BACK*0.5
				Wall.BACK:
					m_transform = m_transform.rotated(Vector3.UP, deg2rad(180))
					m_transform.origin = m_origin + Vector3.FORWARD*0.5
			
			transform_packages[index].append(m_transform)
	
	for i in mesh_packages.size():
		add_multi_mesh_maker_trans(mesh_packages[i], transform_packages[i])
	# generate wall top
	var top_transforms: Array
	for i in data.wall_data:
		top_transforms.append(Transform(Basis(), Vector3(i[0].x, 3.0, i[0].y)))
	add_multi_mesh_maker_trans(data.wall_top, top_transforms)
	# generate wall collision
	var position_data: Array
	for i in data.wall_data:
		position_data.append(i[0])
	var collision_generator: CollisionGenerator = create_node(CollisionGenerator.new())
	collision_generator.name = "CollisionGenerator"
	collision_generator.set_display_folded(true)
	collision_generator.generate_shapes(position_data, data.wall_shape)
	
	#generate nav mesh
	var st := SurfaceTool.new()
	for i in data.floor_data:
		for p in i[1]:
			var mesh_transform: Transform = Transform(Basis(), Vector3(p.x, 0.0, p.y))
			st.append_from(nav_mesh, 0, mesh_transform)
	var navigation: Navigation = create_node(Navigation.new())
	navigation.hide()
	var navigation_mesh_inst: NavigationMeshInstance = create_node(NavigationMeshInstance.new(), navigation)
	navigation_mesh_inst.navmesh = NavigationMesh.new()
	navigation_mesh_inst.navmesh.create_from_mesh(st.commit())
	


func create_node(node_new: Node, parent: Node=self) -> Node:
	parent.add_child(node_new)
	node_new.set_owner(get_tree().edited_scene_root)
	return node_new


func create_multi_mesh_maker() -> MultiMeshMaker:
	var multi_mesh_new: MultiMeshMaker = create_node(MultiMeshMaker.new())
	multi_mesh_new.use_in_baked_light = true
	return multi_mesh_new


func add_multi_mesh_maker(mesh_data: Mesh, positions_data: Array) -> void:
	var multi_mesh_new: MultiMeshMaker = create_multi_mesh_maker()
	multi_mesh_new.multimesh = multi_mesh_new.generate_meshes(mesh_data, positions_data)


func add_multi_mesh_maker_trans(mesh_data: Mesh, transforms_data: Array) -> void:
	var multi_mesh_new: MultiMeshMaker = create_multi_mesh_maker()
	multi_mesh_new.multimesh = multi_mesh_new.generate_meshes_trans(mesh_data, transforms_data)
