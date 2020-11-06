tool
extends Spatial
class_name RoomSystem

signal current_camera_changed(to)

export var room_data: Array = []

var ceiling_mesh := preload("res://demo_assets/wall_top.tres")
var collisions_shape: Shape = preload("res://addons/RoomTool/collision_shape.shape")

var editor: RoomsEditor


func _ready():
	if not Engine.is_editor_hint():
		for i in self.get_children():
			i.show()
		return
	
	#setup editor
	editor = preload("res://addons/RoomTool/Editor/RoomEditor.tscn").instance()
	editor.hide()
	self.add_child(editor)
	load_in_editor()


# ----- EDITOR

func enter_editor():
	for i in self.get_children():
		if i is LevelRoom:
			i.hide()
	
	editor.show()


func exit_editor():
	for i in self.get_children():
		if i is LevelRoom:
			i.hide()
		else: i.show()
	
	editor.hide()


func save_from_editor():
	#masonry_data.free()
	self.room_data = editor.save_rooms()


func load_in_editor():
	editor.load_rooms(room_data)


# ----- GENERATOR

func generate() -> void:
	for i in self.get_children():
		if i is LevelRoom:
			i.name = "QueuedForDeletion"
			i.queue_free()
	
	for r in room_data:
		#setup
		var room_new: LevelRoom = create_node(LevelRoom.new())
		var room_origin: Vector3 = Vector3.ZERO
		for v in r:
			room_origin += v
		room_origin /= r.size()
		room_new.transform.origin = room_origin
		room_new.set_display_folded(true)
		room_new.hide()
		
		var room_ceiling: MultiMeshMaker = create_node(MultiMeshMaker.new(), room_new)
		var ceiling_transforms: Array = []
		for p in r:
			var c_transform := Transform(Basis(), Vector3(p.x, 3.0, p.z) - room_origin)
			ceiling_transforms.append(c_transform)
		
		room_ceiling.multimesh = room_ceiling.generate_meshes_trans(ceiling_mesh, ceiling_transforms)
		
		room_new.ceiling = room_new.get_path_to(room_ceiling)
		
		var room_camera: Camera = create_node(Camera.new(), room_new)
		room_camera.translate(Vector3.UP*9.0)
		room_camera.rotate_x(-PI/2)
		room_camera.cull_mask = 1
		
		room_new.camera = room_new.get_path_to(room_camera)
		
		if collisions_shape == null:
			print_debug("Can't generate. Shape == null!")
			return
	
		for i in r:
			var collision_new: CollisionShape = create_node(CollisionShape.new(), room_new)
			collision_new.shape = collisions_shape
			collision_new.transform.origin = i - room_origin


func create_node(node_new: Node, parent = self) -> Node:
	parent.add_child(node_new)
	node_new.set_owner(get_tree().edited_scene_root)
	return node_new

