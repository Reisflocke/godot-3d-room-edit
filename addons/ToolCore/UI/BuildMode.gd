tool
extends VBoxContainer

signal mode_selected(id)

var current_mode: int = 0

func _ready():
	var radio_buttons: Array = self.get_children()
	for i in radio_buttons:
		if not i is CheckBox:
			radio_buttons.erase(i)
	
	for i in radio_buttons.size():
		radio_buttons[i].connect("pressed", self, "set_build_mode", [i])


func set_build_mode(id: int):
	current_mode = id
	emit_signal("mode_selected", id)
