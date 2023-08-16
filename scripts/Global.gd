extends Node


var activePlayer : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("quit_game"):
		if not OS.has_feature("web"):
			get_tree().quit()
