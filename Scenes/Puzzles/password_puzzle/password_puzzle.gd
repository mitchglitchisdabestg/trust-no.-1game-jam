extends Puzzle

@onready var line_edit: LineEdit = $MainPanel/Panel/MarginContainer/VBoxContainer/LineEdit
@onready var submit_button: Button = $MainPanel/Panel/MarginContainer/VBoxContainer/HBoxContainer/SubmitButton
@onready var clear_button: Button = $MainPanel/Panel/MarginContainer/VBoxContainer/HBoxContainer/ClearButton
@onready var close_button: Button = $CloseButton


func submit () -> void:
	print(line_edit.text)

func _ready() -> void:
	close_button.pressed.connect(quit_game)
	line_edit.text_submitted.connect(submit)
	submit_button.pressed.connect(submit)
