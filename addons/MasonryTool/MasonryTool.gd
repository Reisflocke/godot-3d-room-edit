tool
extends Spatial
class_name Masonry

export var masonry_data: Resource

var generator: MasonryGenerator
var editor: MasonryEditor


func _ready():
	#get generator
	if self.has_node("Generator"):
		generator = self.get_node("Generator")
		generator.show()
	
	if not Engine.is_editor_hint():
		return
	
	if not masonry_data:
		masonry_data = MasonryData.new()
	
	#setup editor
	editor = preload("res://addons/MasonryTool/Editor/MasonryEditor.tscn").instance()
	editor.hide()
	self.add_child(editor)
	load_in_editor()


# ----- EDITOR

func enter_editor():
	if generator:
		generator.hide()
	editor.show()


func exit_editor():
	if generator:
		generator.show()
	editor.hide()


func save_from_editor():
	#masonry_data.free()
	self.masonry_data = editor.save_masonry()


func load_in_editor(data = masonry_data):
	editor.load_masonry(data)


# ----- GENERATOR

func generate() -> void:
	if not generator or not is_instance_valid(generator) or not generator.is_inside_tree():
		generator = _setup_generator()
	generator.generate_masonry(masonry_data)


func _setup_generator() -> MasonryGenerator:
	if self.has_node("Generator"):
		var g: MasonryGenerator = self.get_node("Generator")
		return g
	var generator_new: MasonryGenerator = MasonryGenerator.new()
	generator_new.name = "Generator"
	self.add_child(generator_new)
	generator_new.set_owner(get_tree().edited_scene_root)
	return generator_new
