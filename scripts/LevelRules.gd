extends Node


@export var prey_instances : Array[Node2D]

var prey_count : int

func _ready():
	prey_count = prey_instances.size()

func _process(_delta):
	var c : int = 0
	for item in prey_instances:
		if not item:
			c += 1
	
	if c >= prey_count:
		await get_tree().create_timer(5).timeout
		Global.load_next_level()
