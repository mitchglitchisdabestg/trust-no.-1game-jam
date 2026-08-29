extends Area3D

@export var tape_subtitle: String = "If you're waking up in the basement again, don't panic. This is iteration 12...I think. Head straight through the filing cabinets and find the terminal next to the water boiler. Fix the wiring to open the door to the stairwell. Whatever you do, do not touch the boiler!"

@export var subtitle_box: PanelContainer 
@export var subtitle_text: Label 

var is_player_near: bool = false
@onready var audio_player = $AudioStreamPlayer3D

# Automatically targets the Label3D child node we just created
@onready var prompt_3d: Label3D = $InteractPrompt3D

func _ready() -> void:
	if subtitle_box != null:
		subtitle_box.hide()
	# Hide the 3D prompt when the game starts
	if prompt_3d != null:
		prompt_3d.hide()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player" or body.name == "Player":
		is_player_near = true
		# Show the floating world text when close
		if prompt_3d != null:
			prompt_3d.show()

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player" or body.name == "Player":
		is_player_near = false
		# Hide the floating text when walking away
		if prompt_3d != null:
			prompt_3d.hide()

func _input(_event: InputEvent) -> void:
	if is_player_near and Input.is_action_just_pressed("Interact"):
		
		# Hide the floating prompt the second they press E
		if prompt_3d != null:
			prompt_3d.hide()
		
		if audio_player.stream != null:
			audio_player.play()
			
		if subtitle_text != null:
			subtitle_text.text = tape_subtitle
			
		if subtitle_box != null:
			subtitle_box.show()
			get_tree().create_timer(7.0).timeout.connect(hide_text)
			
		$CollisionShape3D.set_deferred("disabled", true)

func hide_text() -> void:
	if subtitle_box != null:
		subtitle_box.hide()
