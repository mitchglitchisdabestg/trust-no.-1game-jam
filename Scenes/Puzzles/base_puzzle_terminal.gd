class_name Terminal 
extends Node3D

@export var label: Label3D
#@export var game

func _ready() -> void:
	label.hide()

func interact () -> void:
	play_game()

func show_prompt () -> void:
	label.show()

func hide_prompt () -> void:
	label.hide()

func play_game () -> void:
	print("Opened Game")
	
