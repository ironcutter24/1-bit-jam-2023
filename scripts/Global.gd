extends Node


@export var scene_list : Array[PackedScene]
@export var win_scene : PackedScene

var current_level : int = 0
var activePlayer : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("quit_game"):
		if not OS.has_feature("web"):
			get_tree().quit()

func load_next_level() -> void:
	current_level += 1
	
	if current_level == scene_list.size():
		get_tree().change_scene_to_packed(win_scene)
		return
	elif current_level > scene_list.size():
		return
	
	get_tree().change_scene_to_packed(scene_list[current_level])

func reload_current_level() -> void:
	get_tree().reload_current_scene()

func reset_game():
	current_level = 0
	get_tree().change_scene_to_packed(scene_list[current_level])
