extends Node

enum Statuses {World,Puzzle}

var current_status: Statuses = Statuses.World

func set_status(new_status: Statuses) -> void:
	current_status = new_status
	print(current_status)
