extends Area
class_name Interaction

signal player_entered(player_position)
signal player_exited
signal player_interact

var is_player_entered: bool = false


func _ready():
	connect("body_entered", self, "_on_Interaction_body_entered")
	connect("body_exited", self, "_on_Interaction_body_exited")


func _unhandled_input(event):
	if event.is_action_pressed("ui_interact") and is_player_entered:
		emit_signal("player_interact")


func _on_Interaction_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_entered = true
		emit_signal("player_entered", body.global_transform.origin)


func _on_Interaction_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_player_entered = false
		emit_signal("player_exited")

