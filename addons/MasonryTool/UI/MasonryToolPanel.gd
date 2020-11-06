tool
extends Control

enum ToolMode{BUILD, PAINT}
enum PartMode{FLOOR, WALL}

export (ShortCut) var shortcut_build: ShortCut
export (ShortCut) var shortcut_paint: ShortCut
export (ShortCut) var shortcut_floor: ShortCut
export (ShortCut) var shortcut_wall: ShortCut

var editor_interface: EditorInterface
var edited_object: Masonry setget set_edited_object

onready var tool_mode := $ToolMode
onready var part_mode := $PartMode
onready var part_floor := $PartMode/Floor
onready var part_wall := $PartMode/Wall
onready var build_mode := tool_mode.get_node("Build/VBoxContainer/HBoxContainer/BuildMode")

onready var generate_button := $HBoxContainer/GenerateButton


#setup
func _ready():
	
	
	if editor_interface:
		part_floor.resource_preview = editor_interface.get_resource_previewer()
		part_wall.resource_preview = editor_interface.get_resource_previewer()


# ----- SHORTCUTS -----

func _unhandled_input(event) -> void:
	if shortcut_build.is_shortcut(event):
		tool_mode.current_tab = ToolMode.BUILD
	if shortcut_paint.is_shortcut(event):
		tool_mode.current_tab = ToolMode.PAINT
	
	if shortcut_floor.is_shortcut(event):
		part_mode.current_tab = PartMode.FLOOR
	if shortcut_wall.is_shortcut(event):
		part_mode.current_tab = PartMode.WALL


func set_edited_object(object_new: Masonry):
	if edited_object == object_new:
		return
		
		#cleanup old objects connection
	if edited_object and not object_new: # cleanup
		#generator
		generate_button.disconnect("pressed", edited_object, "generate")
		# load/save
		$HBoxContainer2/SaveButton.disconnect("pressed", edited_object, "save_from_editor")
		$HBoxContainer2/LoadButton.disconnect("pressed", edited_object, "load_in_editor")
		#editing
		edited_object.exit_editor()
		tool_mode.disconnect("tab_selected", edited_object.editor, "set_tool_mode")
		build_mode.disconnect("mode_selected", edited_object.editor, "set_build_mode")
		part_mode.disconnect("tab_selected", edited_object.editor, "set_part_mode")
		part_mode.get_node("Floor").disconnect("part_selected", edited_object.editor, "set_floor_part")
		part_mode.get_node("Wall").disconnect("part_selected", edited_object.editor, "set_wall_part")
		edited_object.editor.disconnect("pick_part", part_mode, "pick_part")
	
	#setup new objects connections
	if object_new: #setup
		#generator
		generate_button.connect("pressed", object_new, "generate")
		# load/save
		$HBoxContainer2/SaveButton.connect("pressed", object_new, "save_from_editor")
		$HBoxContainer2/LoadButton.connect("pressed", object_new, "load_in_editor")
		#editing
		object_new.enter_editor()
		tool_mode.connect("tab_selected", object_new.editor, "set_tool_mode")
		tool_mode.emit_signal("tab_selected", tool_mode.current_tab)
		build_mode.connect("mode_selected", object_new.editor, "set_build_mode")
		build_mode.emit_signal("mode_selected", build_mode.current_mode)
		part_mode.connect("tab_selected", object_new.editor, "set_part_mode")
		part_mode.emit_signal("tab_selected", part_mode.current_tab)
		part_mode.get_node("Floor").connect("part_selected", object_new.editor, "set_floor_part")
		part_mode.get_node("Floor").emit_current_item()
		part_mode.get_node("Wall").connect("part_selected", object_new.editor, "set_wall_part")
		part_mode.get_node("Wall").emit_current_item()
		object_new.editor.connect("pick_part", part_mode, "pick_part")
	
	edited_object = object_new
