extends Node

signal open_door (door_ID: int)

func emit_open_door (door_ID: int) -> void:
	open_door.emit(door_ID)
