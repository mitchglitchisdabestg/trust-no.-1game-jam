extends StaticBody3D

@export var tape_subtitle: String = "If you're waking up in the basement again, don't panic. This is iteration 12...I think. Head straight through the filing cabinets and find the terminal next to the water boiler. Fix the wiring to open the door to the stairwell. Whatever you do, do not touch the boiler!"

@export var subtitle_box: PanelContainer 
@export var subtitle_text: Label 

var is_player_near: bool = false
@onready var audio_player = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Automatically targets the Label3D child node we just created
@onready var prompt_3d: Label3D = $InteractPrompt3D

func hide_text() -> void:
	if !subtitle_box: return
	
	subtitle_box.hide()
	queue_free()

func play_memo() -> void:
	# Hide the floating prompt the second they press E
	if prompt_3d:
		prompt_3d.hide()
	
	if audio_player.stream:
		audio_player.play()
		
		
	if subtitle_text:
		subtitle_text.text = tape_subtitle
		
	if subtitle_box:
		subtitle_box.show()
		get_tree().create_timer(7.0).timeout.connect(hide_text)
	
	collision_shape_3d.set_deferred("disabled", true)

func interact () -> void:
	#play_memo()
	# To use old logic, uncomment line above and comment line below
	pickup_memo()

func pickup_memo () -> void:
	collision_shape_3d.set_deferred("disabled", true)
	hide()
	SignalBus.emit_pickup_casette(audio_player.stream)
	SignalBus.emit_subtitles(tape_subtitle)

func show_prompt () -> void:
	prompt_3d.show()

func hide_prompt () -> void:
	prompt_3d.hide()

func _ready() -> void:
	if subtitle_box != null:
		subtitle_box.hide()
	# Hide the 3D prompt when the game starts
	if prompt_3d != null:
		prompt_3d.hide()

#func _on_body_entered(body: Node3D) -> void:
	#if body.name == "player" or body.name == "Player":
		#is_player_near = true
		# Show the floating world text when close
		#if prompt_3d != null:
			#prompt_3d.show()
#
#func _on_body_exited(body: Node3D) -> void:
	#if body.name == "player" or body.name == "Player":
		#is_player_near = false
		# Hide the floating text when walking away
		#if prompt_3d != null:
			#prompt_3d.hide()
	pass
