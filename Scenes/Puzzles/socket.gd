class_name Socket extends Button

@export var socket_colour: String
@export var socket_side: String

signal socket_pressed(socket)

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	socket_pressed.emit(self)
