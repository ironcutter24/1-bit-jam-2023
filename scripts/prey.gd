class_name Prey
extends CharacterBody2D


const MOVE_SPEED = 66.0
const FLEE_DISTANCE = 40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_panicking : bool = false

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var animVFX : AnimatedSprite2D = $AnimVFX
@onready var idle_sound : AudioStreamPlayer2D = $Audio/IdleSound
@onready var fear_sound : AudioStreamPlayer2D = $Audio/FearSound

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var fromPlayer = global_position - Global.activePlayer.global_position
	var dist = fromPlayer.length()
	
	var direction = 0
	if dist < FLEE_DISTANCE:
		direction = sign(fromPlayer.x)
		
		if not $FearTimer.time_left:
			animVFX.play("cry")
			play_fear_sound()
		
		$FearTimer.start()
	else:
		if not $FearTimer.time_left:
			animVFX.play("sing")
			play_idle_sound()
	
	if direction:
		velocity.x = direction * MOVE_SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
	
	var cached_pos = global_position
	move_and_slide()
	
	if cached_pos == global_position and direction:
		anim.play("03_2_cry_loop")
		is_panicking = true
		return
	
	anim.play("01_walk" if direction else "00_idle")
	
	is_panicking = false


func play_idle_sound():
	fear_sound.stop()
	if not idle_sound.playing:
		idle_sound.play()

func play_fear_sound():
	idle_sound.stop()
	if not fear_sound.playing:
		fear_sound.play()
