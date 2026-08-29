class_name Terminal extends Node3D

@export var label: Label3D
@export var puzzle_scene: PackedScene
@export var door_ID_to_open : int

@onready var original_text: String = label.text
@onready var voice_memo_player: AudioStreamPlayer3D = $VoiceMemoPlayer
@onready var insert_casette_noise: AudioStreamPlayer3D = $InsertCasetteNoise

func get_has_casette () -> bool:
	return true if Status.stored_casette_stream else false

func _ready() -> void:
	label.hide()

func interact () -> void:
	if !get_has_casette():
		play_game()
	else:
		play_stored_casette()

func show_prompt () -> void:
	label.text = original_text if get_has_casette() else "Press E to Insert Casette"
	
	label.show()

func hide_prompt () -> void:
	label.hide()

func play_stored_casette() -> void:
	voice_memo_player.stream = Status.stored_casette_stream
	Status.set_stored_casette_stream(null)
	SignalBus.emit_insert_casette()
	voice_memo_player.play()
	insert_casette_noise.play()
	#Handle subtitles

func play_game () -> void:
	if !puzzle_scene: return
	
	var puzzle = puzzle_scene.instantiate()
	get_tree().current_scene.add_child(puzzle)
	print(puzzle is Puzzle)
	puzzle.game_won.connect(on_game_won)
	puzzle.visible = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func on_game_won () -> void:
	SignalBus.emit_open_door(door_ID_to_open)
