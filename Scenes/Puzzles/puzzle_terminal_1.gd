extends Terminal

@export var door_ID_to_open : int = 1111

@export var puzzle_scene: PackedScene

func play_game () -> void:
	if puzzle_scene:
		var puzzle = puzzle_scene.instantiate()
		get_tree().current_scene.add_child(puzzle)
		puzzle.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	
	#SignalBus.emit_open_door(door_ID_to_open)
	#print(door_ID_to_open)
