class_name Terminal extends Node3D

@export var label: Label3D
@export var puzzle_scene: PackedScene
@export var door_ID_to_open : int

func _ready() -> void:
	label.hide()

func interact () -> void:
	play_game()

func show_prompt () -> void:
	label.show()

func hide_prompt () -> void:
	label.hide()

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
