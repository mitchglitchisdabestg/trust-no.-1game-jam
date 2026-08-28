extends Node

signal open_door (door_ID: int)

func emit_open_door (door_ID: int) -> void:
	print(door_ID)
	open_door.emit(door_ID)
