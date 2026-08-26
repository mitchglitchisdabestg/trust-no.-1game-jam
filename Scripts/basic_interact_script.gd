extends Node3D

@export var label: Label3D

func _ready() -> void:
	label.hide()

func interact () -> void:
	print("Interacted!!")
	#queue_free()

func show_prompt () -> void:
	label.show()

func hide_prompt () -> void:
	label.hide()
