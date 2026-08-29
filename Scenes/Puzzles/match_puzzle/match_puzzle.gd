extends Control

@onready var show_success_timer: Timer = $ShowSuccessTimer

func _ready() -> void:
	pass # Attach tile signals

func reset_game() -> void:
	pass #flip all to hidden

func on_tile_pressed(_tile) -> void:
	pass # handle detection logic

func quit_game() -> void:
	pass

func on_win() -> void:
	pass
