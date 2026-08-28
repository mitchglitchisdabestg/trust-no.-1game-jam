extends Terminal

@export var door_ID_to_open : int = 1111

func play_game () -> void:
	SignalBus.emit_open_door(door_ID_to_open)
	#print(door_ID_to_open)
