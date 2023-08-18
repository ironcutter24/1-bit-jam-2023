extends Node


@export var levels : Array[PackedScene]

var current_level : int = 0
var activePlayer : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("quit_game"):
		if not OS.has_feature("web"):
			get_tree().quit()

func load_next_level() -> void:
	current_level += 1
	get_tree().change_scene_to_packed(levels[current_level])

func reload_current_level() -> void:
	get_tree().reload_current_scene()
