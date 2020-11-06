tool
extends Interaction
class_name LevelRoom

signal room_entered
signal room_exited

export var ceiling: NodePath
export var camera: NodePath

var room_system: Spatial


func _ready():
	if Engine.is_editor_hint():
		return
	room_system = get_parent()
	#connect
	self.connect("player_entered", self, "player_enter_room")
	room_system.connect("current_camera_changed", self, "player_exit_room")


func player_enter_room(position: Vector3) -> void:
	get_node(ceiling).hide()
	get_node(camera).make_current()
	room_system.emit_signal("current_camera_changed", get_node(camera))
	
	emit_signal("room_entered")


func player_exit_room(to: Camera) -> void:
	if not to == get_node(camera):
		get_node(ceiling).show()
	
	emit_signal("room_exited")

