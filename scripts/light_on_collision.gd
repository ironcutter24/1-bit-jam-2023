extends AnimatedSprite2D


@onready var body : RigidBody2D = owner

func _ready():
	body.body_entered.connect(_on_body_entered)
	visible = false

func _on_body_entered():
	visible = true
