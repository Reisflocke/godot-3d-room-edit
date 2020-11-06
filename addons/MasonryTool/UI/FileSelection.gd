tool
extends FileSelectionBase

export var preview_size: Vector2 = Vector2(64, 64)

var resource_preview: EditorResourcePreview


func generate_item_list(load_path: String = line_edit.text) -> void:
	if not load_path.ends_with("/"):
		load_path += "/"
	
	var dir := Directory.new()
	if not dir.open(load_path) == OK:
		loading_error.show()
		return
	loading_error.hide()
	
	var folders: PoolStringArray = []
	var files: PoolStringArray = []
	
	dir.list_dir_begin(true)
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			folders.append(file_name)
		else:
			files.append(file_name)
		file_name = dir.get_next()
	
	item_list.clear()
	
	add_dir_up_item(load_path)
	
	for i in folders:
		var dir_path: String = load_path+i+"/"
		add_item(i.capitalize(), icon_folder, dir_path, dir_path)
	
	for i in files:
		for t in file_types:
			if i.ends_with(t):
				var file_path: String = load_path+i
				var id = add_item(get_beautified_file_name(i), icon_placeholder, file_path, load(file_path))
				if resource_preview:
					resource_preview.queue_resource_preview(file_path, self, "_on_preview_loaded", null)


func go_to_dir(path: String, item=null) -> void:
	line_edit.text = path
	generate_item_list()
	
	if item:
		for i in item_list.get_item_count():
			if not item_list.get_item_metadata(i) is Object:
				continue
			
			if item_list.get_item_metadata(i) == item:
				item_list.select(i)


func emit_current_item() -> void:
	if not item_list.is_anything_selected():
		return
	_on_ItemList_item_selected(item_list.get_selected_items()[0])


func _on_preview_loaded(path: String, texture: Texture, userdata):
	#var preview_image := texture.get_data()
	#print_debug(preview_image) # Retuns [Object:null]
	#preview_image.resize(int(preview_size.x), int(preview_size.y), Image.INTERPOLATE_CUBIC)
	#var preview_texture: ImageTexture = ImageTexture.new()
	#preview_texture.create_from_image(preview_image)
	
	for i in item_list.get_item_count():
		if item_list.get_item_tooltip(i) == path:
			item_list.set_item_icon(i, texture)


func _on_ItemList_item_selected(index):
	var meta_data = item_list.get_item_metadata(index)
	if meta_data is String:
		go_to_dir(meta_data)
		return
	
	emit_signal("part_selected", meta_data)
