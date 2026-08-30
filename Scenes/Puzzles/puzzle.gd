class_name Puzzle extends Control
signal game_won
var password: String = "1111"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("SkipPuzzle"):
		on_win()

func on_win() -> void:
	Status.set_status(Status.Statuses.World)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_won.emit()
	
	queue_free()

func quit_game() -> void:
	Status.set_status(Status.Statuses.World)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
