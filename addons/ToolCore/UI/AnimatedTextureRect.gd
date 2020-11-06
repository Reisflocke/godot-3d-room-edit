tool
extends TextureRect

func set_frame(id: int) -> void:
	if not texture is AnimatedTexture:
		return
	
	var t: AnimatedTexture = texture
	t.current_frame = id
