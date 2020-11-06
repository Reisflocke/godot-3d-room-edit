tool
extends EditorBase
class_name MasonryEditor

signal pick_part(type, dir_path, part)

enum ToolMode{BUILD, PAINT}
enum PartMode{FLOOR, WALL}
enum BuildMode{SINGLE, LINE}

var tool_mode = ToolMode.BUILD setget set_tool_mode
var part_mode = PartMode.FLOOR setget set_part_mode

var floor_part: Mesh setget set_floor_part
var wall_part: Mesh setget set_wall_part
var build_mode = BuildMode.SINGLE setget set_build_mode

var detection_shape: Shape = preload("res://addons/MasonryTool/Editor/detection_shape.shape")

var draw_drag: bool = false
var drag_beginning: Vector3 = Vector3.ZERO

const FloorEdit: String = "FloorEdit"
const WallEdit: String = "WallEdit"


# ----- Input -----

func editor_input(camera: Camera, event) -> void:
	if event is InputEventMouseButton:
		if not event.button_index == BUTTON_LEFT:
			return
		
		var click_hit = get_click_hit_ground(camera, event.position)
		var click_collision := get_click_collision(camera, event.position)
		var collider: Node
		if not click_collision.empty():
			collider = click_collision["collider"]
		
		#left button released
		if not event.pressed:
			if not draw_drag or not click_hit is Vector3:
				return
			draw_drag = false
			drag_beginning.round()
			var drag_end: Vector3 = click_hit.round()
			var drag_b_to_e: Vector3 = (-drag_beginning + drag_end)
			var steps: float = max(abs(drag_b_to_e.x), abs(drag_b_to_e.z))
			match build_mode:
				BuildMode.LINE:
					for i in steps:
						var position: Vector3 = drag_beginning + (drag_b_to_e*(i/steps))
						var collisions := get_area(drag_beginning + (drag_b_to_e*(i/steps)))
						var clear_for_building: bool = true
						for c in collisions:
							if c["collider"].is_in_group(FloorEdit) or c["collider"].is_in_group("WallButtom"):
								clear_for_building = false
						if clear_for_building:
							build(position, null)
			return
		
		#left button pressed
		if tool_mode == ToolMode.BUILD:
			
			if Input.is_key_pressed(KEY_SHIFT) and collider:
				demolish(collider)
			else:
				if not build_mode == BuildMode.SINGLE:
					drag_beginning = click_hit
					draw_drag = true
					return
				
				build(click_hit, collider)
		
		elif tool_mode == ToolMode.PAINT and collider:
			if Input.is_key_pressed(KEY_SHIFT):
				if collider.is_in_group(FloorEdit):
					var mesh: Mesh = collider.variant
					floor_part = mesh
					emit_signal("pick_part", PartMode.FLOOR, mesh.resource_path.get_base_dir(), mesh)
				elif collider.is_in_group(WallEdit):
					var mesh: Mesh = collider.variant
					wall_part = mesh
					emit_signal("pick_part", PartMode.WALL, mesh.resource_path.get_base_dir(), mesh)
			else:
				match part_mode:
					PartMode.FLOOR:
						if not collider.is_in_group(FloorEdit):
							return
						if not collider.variant == floor_part:
							collider.variant = floor_part
					PartMode.WALL:
						if not collider.is_in_group(WallEdit):
							return
						if not collider.variant == wall_part:
							collider.variant = wall_part


# ----- Utilities
func build(click_hit, collider):
	if not click_hit or collider:
		return
	var input_origin := get_input_origin(click_hit)
	var creation_point: Vector2 = Vector2(input_origin.x, input_origin.z)
	match part_mode:
		PartMode.FLOOR:
			if floor_part:
				create_floor(floor_part, creation_point)
		PartMode.WALL:
			if wall_part:
				create_wall([wall_part, wall_part, wall_part, wall_part], creation_point)


func demolish(collider):
	match part_mode:
		PartMode.FLOOR:
			if collider.is_in_group(FloorEdit):
				collider.queue_free()
		PartMode.WALL:
			if collider.is_in_group(WallEdit) or collider.is_in_group("WallTop"):
				if collider.owner.is_in_group("WallContainer"):
					collider.owner.queue_free()


func get_area(position: Vector3, area_shape: Shape = detection_shape) -> Array:
	var area_new: PhysicsShapeQueryParameters = PhysicsShapeQueryParameters.new()
	
	area_new.transform.origin = get_input_origin(position)
	
	area_new.set_shape(area_shape)
	
	var space_state := get_world().direct_space_state
	return space_state.intersect_shape(area_new)


# ----- SETGET -----

func set_tool_mode(value):
	tool_mode = value


func set_part_mode(value):
	part_mode = value


func set_floor_part(value):
	floor_part = value


func set_wall_part(value):
	wall_part = value


func set_build_mode(value):
	build_mode = value
