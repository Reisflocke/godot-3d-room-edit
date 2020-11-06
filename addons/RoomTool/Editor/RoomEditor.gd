tool
extends "res://addons/RoomTool/Editor/EditorBase.gd"
class_name RoomsEditor
# Room Editor

enum BuildMode{SINGLE, LINE}

export var detection_shape: Shape = preload("res://addons/RoomTool/Editor/detection_shape.shape")

var build_mode = BuildMode.SINGLE setget set_build_mode

var draw_drag: bool = false
var drag_beginning: Vector3 = Vector3.ZERO

const TileEdit := "TileEdit"


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
							if c["collider"].is_in_group(TileEdit):
								clear_for_building = false
						if clear_for_building:
							build(position)
			return
		
		#left button pressed
		if Input.is_key_pressed(KEY_SHIFT) and collider:
			var area_colliders := get_area(click_hit)
			for i in area_colliders:
				demolish(i["collider"])
		else:
			if not build_mode == BuildMode.SINGLE:
				drag_beginning = click_hit
				draw_drag = true
				return
			
			build(click_hit)


# ----- Utilities
func build(click_hit):
	var detected_collision: = false
	var area_colliders := get_area(click_hit)
	for i in area_colliders:
		if i["collider"].is_in_group(TileEdit):
			detected_collision = true
	if not click_hit or detected_collision:
		return
	var creation_point: Vector3 = get_input_origin(click_hit)
	create_tile(current_room, creation_point)


func demolish(collider):
	if collider.is_in_group(TileEdit):
		collider.queue_free()


func get_area(position: Vector3, area_shape: Shape = detection_shape) -> Array:
	var area_new: PhysicsShapeQueryParameters = PhysicsShapeQueryParameters.new()
	
	area_new.transform.origin = get_input_origin(position)
	
	area_new.set_shape(area_shape)
	
	var space_state := get_world().direct_space_state
	return space_state.intersect_shape(area_new)


# ----- SETGET -----

func set_build_mode(value):
	build_mode = value
