class_name PlayerCamera extends Camera3D

const SENSITIVITY : float = 0.2

@export_subgroup("Nodes")
@export var player : Player
@export var head : Node3D
@export var interaction_ray: RayCast3D
@export var reticle: ColorRect

@export_subgroup("Configuration")
@export var reticle_size : float = 0.15

var current_interaction_target: Node3D = null
var mouse_locked : bool = true

func interact_with_object() -> void:
	if !mouse_locked or !interaction_ray.is_colliding(): return
	var hit_object = interaction_ray.get_collider()
	
	if hit_object and hit_object.has_method("interact"):
		hit_object.interact()

func check_ray_collision() -> void:
	if !interaction_ray.is_colliding(): 
		hide_current_prompt()
		return
	
	var hover_collider : Node3D = interaction_ray.get_collider()
	
	if !is_instance_valid(hover_collider) or !hover_collider.has_method("interact") or !hover_collider.has_method("show_prompt"): 
		hide_current_prompt()
		return
	
	if current_interaction_target == hover_collider: return
	
	if current_interaction_target:
		current_interaction_target.hide_prompt()
	
	current_interaction_target = hover_collider
	current_interaction_target.show_prompt()

func hide_current_prompt() -> void:
	if current_interaction_target:
		current_interaction_target.hide_prompt()
		current_interaction_target = null

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
	if Status.current_status == Status.Statuses.Puzzle: return
	
	if event is InputEventMouseMotion and mouse_locked and player:
		player.rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clampf(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
	if event.is_action_pressed("MouseLock"):
		toggle_mouse_lock()
	if event.is_action_pressed("Interact"):
		interact_with_object()

func _physics_process(_delta: float) -> void:
	check_ray_collision()
