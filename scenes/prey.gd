extends CharacterBody2D


const MOVE_SPEED = 40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var fromPlayer = global_position - Global.activePlayer.global_position
	var dist = fromPlayer.length()
	
	var direction = 0
	if dist < 60:
		direction = sign(fromPlayer.x)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)

	move_and_slide()
