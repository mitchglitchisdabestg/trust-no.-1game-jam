extends StaticBody3D

@export var label: Label3D

@onready var elevator: Elevator = $"../../.."

func _ready() -> void:
	label.hide()

func interact () -> void:
	elevator.go_up()
	queue_free()

func show_prompt () -> void:
	label.show()

func hide_prompt () -> void:
	label.hide()
