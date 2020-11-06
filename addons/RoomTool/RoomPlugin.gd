tool
extends EditorPlugin

var room_tool_node: Script = preload("res://addons/RoomTool/RoomTool.gd")
var room_tool_icon: Texture = preload("res://addons/RoomTool/room_icon.png")
var room_tool_panel: Control = preload("res://addons/RoomTool/UI/RoomToolPanel.tscn").instance()


func _enter_tree():
	add_custom_type("RoomSystem", "Spatial", room_tool_node, room_tool_icon)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, room_tool_panel)
	room_tool_panel.hide()


func _exit_tree():
	remove_custom_type("RoomSystem")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, room_tool_panel)
	
	room_tool_panel.queue_free()


func handles(object):
	return object is RoomSystem


func edit(object):
	if object is RoomSystem:
		room_tool_panel.edited_object = object


func make_visible(visible):
	room_tool_panel.visible = visible
	if not visible:
		room_tool_panel.edited_object = null


func forward_spatial_gui_input(camera, event) -> bool:
	var forward = false
	if not room_tool_panel.edited_object:
		return forward
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			forward = true
	
	room_tool_panel.edited_object.editor.editor_input(camera, event)
	
	return forward


func apply_changes():
	if room_tool_panel.edited_object:
		room_tool_panel.edited_object.save_from_editor()
