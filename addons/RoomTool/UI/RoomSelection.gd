tool
extends ItemList

signal room_selected(room)


func _ready():
	self.connect("item_selected", self, "select_room")


func generate_room_list(data: Array, current_room: Spatial):
	self.clear()
	for i in data:
		add_room(i)
	
	if current_room:
		for i in self.get_item_count():
			if not self.get_item_metadata(i) is Object:
				continue
			
			if self.get_item_metadata(i) == current_room:
				self.select(i)


func add_room(room: Spatial):
	var room_id = self.get_item_count()
	self.add_item(room.name)
	self.set_item_metadata(room_id, room)


func select_room(id: int):
	self.emit_signal("room_selected", get_item_metadata(id))
