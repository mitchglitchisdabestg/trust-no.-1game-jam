class_name Elevator extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var elevator_noise: AudioStreamPlayer3D = $root/ElevatorMain/ElevatorNoise
@onready var button_rise_delay_timer: Timer = $ButtonRiseDelayTimer
@onready var door_open_delay_timer: Timer = $DoorOpenDelayTimer

func _ready() -> void:
	pass

func go_up() -> void:
	animation_player.play_backwards("Open")
	button_rise_delay_timer.start()
	

func _on_open_trigger_body_entered(body: Node3D) -> void:
	if !body is Player: return
	animation_player.play("Open")

func _on_button_rise_delay_timer_timeout() -> void:
	animation_player.play("Lift")

func _on_door_open_delay_timer_timeout() -> void:
	animation_player.play("Open")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Lift":
		door_open_delay_timer.start()
