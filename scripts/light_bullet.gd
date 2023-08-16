extends RigidBody2D


@onready var light = $LightAnimation

var max_velocity = 180.0

func _ready():
	body_entered.connect(_on_body_entered)
	light.visible = false

func _physics_process(_delta):
	if linear_velocity.length() > max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity

func _on_body_entered(_body: Node):
		light.visible = true
