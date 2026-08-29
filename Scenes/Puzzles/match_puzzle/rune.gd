class_name Rune extends Button
@onready var hider: Panel = $Hider

var rune_disabled: bool = false

signal rune_pressed(socket)

func _ready():
	pressed.connect(_on_pressed)

func reveal_icon():
	hider.hide()

func hide_icon():
	hider.show()

func _on_pressed():
	rune_pressed.emit(self)
