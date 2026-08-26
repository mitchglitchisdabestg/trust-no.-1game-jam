class_name Player extends CharacterBody3D

@onready var player_camera: Camera3D = $Head/PlayerCamera
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_audible : bool = true

# Movement constants
const CROUCH_SPEED : float = 2.5
const WALK_SPEED : float = 4.5
const SPRINT_SPEED : float = 7.0
const JUMP_VELOCITY : float = 5.0
const JUMP_MULTIPLIER_ON_RELEASE : float = 0.75 # Used for variable jump height

# Head bob constants
const BOB_FREQ : float = 2.0
const BOB_AMP : float = 0.08

# Feild-Of-View constants
const BASE_FOV : float = 75.0
const FOV_CHANGE : float = 1.75

# Stealth constants
const MIN_AUDIBLE_SPEED : float = 3.0

# Changing variables
var bob_progress : float = 0.0
var current_speed : float = 0.0

#region handlers

func handle_head_bob (time : float) -> Vector3:
	var new_camera_position : Vector3 = Vector3.ZERO
	
	# Goofy ah maths stuff
	new_camera_position.y = sin(time * BOB_FREQ) * BOB_AMP
	new_camera_position.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	return new_camera_position

func handle_lateral_inertia (direction : Vector3, delta : float, amount : float) -> void:
	velocity.x = lerp(velocity.x, direction.x * current_speed, delta * amount)
	velocity.z = lerp(velocity.z, direction.z * current_speed, delta * amount)

func handle_crouch (is_crouching : bool) -> void:
	if is_crouching:
		animation_player.play("crouch")
	else:
		animation_player.play_backwards("crouch")

func decide_is_audible () -> bool:
	return current_speed >= MIN_AUDIBLE_SPEED

#endregion

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and !Input.is_action_pressed("Crouch") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle variable jump height
	if Input.is_action_just_released("Jump") and velocity.y > 0.0:
		velocity.y *= JUMP_MULTIPLIER_ON_RELEASE
	
	# Handle turning off the crouch animation if need be
	if Input.is_action_just_pressed("Crouch"):
		handle_crouch(true)
	
	if Input.is_action_just_released("Crouch"):
		handle_crouch(false)
	
	# Handle sprinting.
	if Input.is_action_pressed("Crouch"):
		current_speed = CROUCH_SPEED
	elif Input.is_action_pressed("Sprint"):
		current_speed = SPRINT_SPEED
	else:
		current_speed = WALK_SPEED
	
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor() and direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	elif is_on_floor():
		handle_lateral_inertia(direction, delta, 5.0)
	else:
		handle_lateral_inertia(direction, delta, 1.0)
	
	# Handle head bobbing - float(is_on_floor()) will return either 1 or 0.
	bob_progress += velocity.length() * float(is_on_floor()) * delta
	player_camera.transform.origin = handle_head_bob(bob_progress)
	
	# Handle FOV changing with current_speed
	var velocity_clamped = clamp(velocity.length(), 0.5, 100)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	player_camera.fov = lerp(player_camera.fov, target_fov, delta * 8.0)
	
	is_audible = decide_is_audible()
	move_and_slide()
