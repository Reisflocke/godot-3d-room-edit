tool
extends TextureButton

export (bool) var transparency_adjustment := true


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	
	connect("draw", self, "update_button_transparency")


func update_button_transparency():
	var draw_mode = self.get_draw_mode()
	
	match draw_mode:
		DRAW_DISABLED:
			set_label_transparency(0.2)
		DRAW_HOVER:
			set_label_transparency(1.0)
		DRAW_HOVER_PRESSED:
			set_label_transparency(0.4)
		DRAW_NORMAL:
			set_label_transparency(0.8)
		DRAW_PRESSED:
			set_label_transparency(0.4)


func set_label_transparency(alpha_value: float) -> void:
	if not transparency_adjustment:
		return
	
	self.modulate.a = alpha_value
