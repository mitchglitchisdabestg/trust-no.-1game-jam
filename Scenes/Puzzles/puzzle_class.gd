class_name Puzzle extends Control

func on_win() -> void:
	get_parent().queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
