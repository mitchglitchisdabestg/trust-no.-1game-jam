extends Node3D

@export var door_ID: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var open_sound: AudioStreamPlayer3D = $OpenSound

var is_open: bool = false

func open_door () -> void:
	if is_open: return
	open_sound.play()
	animation_player.stop()
	animation_player.play("open")
	is_open = true

func close_door () -> void:
	if !is_open: return
	animation_player.stop()
	animation_player.play("close")
	is_open = false

func open_door_if_correct_ID (door_ID_sent: int) -> void:
	if door_ID_sent == door_ID:
		open_door()

func _ready() -> void:
	SignalBus.open_door.connect(open_door_if_correct_ID)
