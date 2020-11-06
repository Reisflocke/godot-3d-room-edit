tool
extends EditorPlugin
# The connection between the Eidotr and the MasonryTool

var masonry_tool_node: Script = preload("res://addons/MasonryTool/MasonryTool.gd")
var masonry_tool_icon: Texture = preload("res://addons/MasonryTool/masonry_icon.png")
var masonry_tool_panel: Control = preload("res://addons/MasonryTool/UI/MasonryToolPanel.tscn").instance()


func _enter_tree():
	add_custom_type("Masonry", "Spatial", masonry_tool_node, masonry_tool_icon)
	masonry_tool_panel.editor_interface = get_editor_interface()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, masonry_tool_panel)
	masonry_tool_panel.hide()


func _exit_tree():
	remove_custom_type("Masonry")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, masonry_tool_panel)
	
	masonry_tool_panel.queue_free()


func handles(object):
	return object is Masonry


func edit(object):
	if object is Masonry:
		masonry_tool_panel.edited_object = object


func make_visible(visible):
	masonry_tool_panel.visible = visible
	if not visible:
		masonry_tool_panel.edited_object = null


func forward_spatial_gui_input(camera, event) -> bool:
	var forward = false
	if not masonry_tool_panel.edited_object:
		return forward
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			forward = true
	
	masonry_tool_panel.edited_object.editor.editor_input(camera, event)
	
	return forward


func apply_changes():
	if masonry_tool_panel.edited_object:
		masonry_tool_panel.edited_object.save_from_editor()
