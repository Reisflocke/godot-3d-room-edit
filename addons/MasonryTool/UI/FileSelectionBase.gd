tool
extends Control
class_name FileSelectionBase

signal part_selected(mesh)

export var default_path: String = ""
export var file_types: PoolStringArray

var icon_placeholder: Texture = preload("res://addons/MasonryTool/UI/icon_placeholder.png")
var icon_folder: Texture = preload("res://addons/MasonryTool/UI/icons/FolderMediumThumb.svg")
var icon_up: Texture = preload("res://addons/MasonryTool/UI/icons/ArrowUp.svg")

onready var line_edit: LineEdit = $VBoxContainer/HBoxContainer/LineEdit
onready var item_list: ItemList = $VBoxContainer/ItemList
onready var loading_error: Label = $VBoxContainer/Label


func _ready():
	line_edit.text = default_path


func add_item(item_name: String, item_icon: Texture, item_tooltip: String, item_metadata) -> int:
	var item_id: int = item_list.get_item_count()
	item_list.add_item(item_name, item_icon)
	item_list.set_item_tooltip(item_id, item_tooltip)
	item_list.set_item_metadata(item_id, item_metadata)
	return item_id


func add_dir_up_item(load_path: String):
	if load_path == "res://" or not load_path.is_abs_path():
		return
	if load_path.get_base_dir() == default_path.get_base_dir():
		return
	#string.left(string.rfind("/", string.length()-2)+1)
	var dir_path: String = load_path.get_base_dir()
	var idx: int = dir_path.rfind("/")
	dir_path.erase(idx, dir_path.length()-idx)
	dir_path += "/"
	add_item(".", icon_up, dir_path, dir_path)


func get_beautified_file_name(file_name: String) -> String:
	return file_name.get_basename().capitalize()

