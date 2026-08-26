extends Camera3D

const SENSITIVITY : float = 0.2

@export var player : Player
@export var head : Node3D
@export var reticle_size : float = 0.15

@onready var reticle: ColorRect = $Reticle

var mouse_locked : bool = true

func toggle_mouse_lock() -> void:
	#Input.MOUSE_MODE_CAPTURED can be changed by the pause menu, so this way is safer than checking mouse_locked.
	mouse_locked = false if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else true
	reticle.visible = mouse_locked
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	reticle.scale.x = reticle_size
	reticle.scale.y = reticle_size

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_locked:
		player.rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clampf(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
	if event.is_action_pressed("MouseLock"):
		toggle_mouse_lock()
