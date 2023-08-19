extends Node


var is_ready : bool = false

func _ready():
	await get_tree().create_timer(1).timeout
	is_ready = true

func _unhandled_input(event):
	if event.is_action_type() and is_ready:
		Global.reset_game()
