extends Node

signal open_door (door_ID: int)

signal pickup_casette (stream_to_play_terminal: AudioStream)
signal insert_casette
signal unlock_elevator

func emit_open_door (door_ID: int) -> void:
	print(door_ID)
	open_door.emit(door_ID)

func emit_pickup_casette (stream_to_play_terminal: AudioStream) -> void:
	pickup_casette.emit(stream_to_play_terminal)

func emit_insert_casette () -> void:
	insert_casette.emit()

func emit_unlock_elevator () -> void:
	unlock_elevator.emit()
