class_name Player
extends CharacterBody2D


const MOVE_SPEED = 60.0
const JUMP_VELOCITY = -220.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var launch_force : float = 200
@export var charge_dots : Sprite2D
@export var bullet_spawn_point : Node2D
@export var light_bullet : PackedScene

@onready var body : Node2D = $Body
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

var is_acting : bool = false
var is_charging : bool = false


func _unhandled_input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("feed") and !is_acting:
		feed()


func _init():
	Global.activePlayer = self

func _process(_delta):
	if Input.is_action_just_pressed("launch") and not is_charging:
		charge_coroutine()

const level_charge_time : float = 0.5
func charge_coroutine():
	is_charging = true
	
	var level = 0
	var time = level_charge_time
	
	while Input.is_action_pressed("launch"):
		await get_tree().process_frame
		time -= get_process_delta_time()
		
		if time <= 0.0:
			level += 1
			charge_dots.frame = level
			time = level_charge_time
	
	launch(Vector2(body.scale.x, -1).normalized() * launch_force * (1 + level) / 4.0)
	charge_dots.frame = 0
	is_charging = false


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
	else:
		velocity.x = 0.0
	
	move_and_slide()


func launch(vel: Vector2):
	var scene = light_bullet.instantiate()
	scene.global_position = bullet_spawn_point.global_position
	scene.apply_central_impulse(vel)
	owner.add_child(scene)


func feed():
	is_acting = true
	
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
