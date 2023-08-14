extends CharacterBody2D


const MOVE_SPEED = 50.0
const JUMP_VELOCITY = -220.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var body : Node2D = $Body
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

var is_acting : bool = false

func _ready():
	feed()

func _process(_delta):
	if Input.is_action_just_pressed("feed"):
		is_acting = true
		feed()
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not is_acting:
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * MOVE_SPEED
			anim.flip_h = direction < 0
			body.set_scale(Vector2(sign(direction), 1))
		else:
			velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		
		if is_on_floor():
			anim.play("01_walk" if direction else "00_idle")
		else:
			anim.play("02_jump")
	
	move_and_slide()

func feed():
	anim.play("03_1_excitement")
	await get_tree().create_timer(1).timeout
	anim.play("03_2_feed")
	await anim.animation_finished
	anim.play("03_3_digest")
	await get_tree().create_timer(4).timeout
	anim.play("03_4_mimic")
	await anim.animation_finished
	anim.play("00_idle")
	await get_tree().create_timer(.5).timeout
	
	is_acting = false
