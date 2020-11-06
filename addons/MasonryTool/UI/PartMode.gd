tool
extends TabContainer


func pick_part(type: int, path: String, part: Mesh) -> void:
	self.current_tab = type
	self.get_tab_control(self.current_tab).go_to_dir(path, part)
