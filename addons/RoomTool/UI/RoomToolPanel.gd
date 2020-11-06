tool
extends VBoxContainer

var edited_object: RoomSystem setget set_edited_object

onready var generate_button := $HBoxContainer2/GenerateButton
onready var room_selection := $RoomSelection
onready var add_room := $HBoxContainer/Add
onready var remove_room := $HBoxContainer/Remove
onready var place_mode := $VBoxContainer/HBoxContainer/BuildMode


func set_edited_object(object_new: RoomSystem):
	if edited_object == object_new:
		return
	
	#cleanup old objects connection
	if edited_object and not object_new: # cleanup
		#generate
		generate_button.disconnect("pressed", edited_object, "generate")
		#editing
		edited_object.exit_editor()
		room_selection.disconnect("room_selected", edited_object.editor, "set_current_room")
		edited_object.editor.disconnect("rooms_changed", room_selection, "generate_room_list")
		add_room.disconnect("pressed", edited_object.editor, "add_room")
		remove_room.disconnect("pressed", edited_object.editor, "remove_room")
		place_mode.disconnect("mode_selected", edited_object.editor, "set_build_mode")
	
	#setup new objects connections
	if object_new: #setup
		#generate
		generate_button.connect("pressed", object_new, "generate")
		#editing
		object_new.enter_editor()
		room_selection.generate_room_list(object_new.editor.get_children(), object_new.editor.current_room)
		room_selection.connect("room_selected", object_new.editor, "set_current_room")
		object_new.editor.connect("rooms_changed", room_selection, "generate_room_list")
		add_room.connect("pressed", object_new.editor, "add_room")
		remove_room.connect("pressed", object_new.editor, "remove_room")
		place_mode.connect("mode_selected", object_new.editor, "set_build_mode")
		object_new.editor.set_build_mode(place_mode.current_mode)
	
	edited_object = object_new
