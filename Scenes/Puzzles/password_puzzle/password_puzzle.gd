extends Puzzle

var password: String = "1111"

@onready var line_edit: LineEdit = $MainPanel/Panel/MarginContainer/VBoxContainer/LineEdit
@onready var submit_button: Button = $MainPanel/Panel/MarginContainer/VBoxContainer/HBoxContainer/SubmitButton
@onready var clear_button: Button = $MainPanel/Panel/MarginContainer/VBoxContainer/HBoxContainer/ClearButton
@onready var close_button: Button = $CloseButton

@onready var success_noise: AudioStreamPlayer = $SuccessNoise
@onready var error_noise: AudioStreamPlayer = $ErrorNoise

@onready var show_success_timer: Timer = $ShowSuccessTimer
@onready var show_failure_timer: Timer = $ShowFailureTimer

@onready var incorrect: Label = $MainPanel/Panel/MarginContainer/VBoxContainer/Incorrect
@onready var correct: Label = $MainPanel/Panel/MarginContainer/VBoxContainer/Correct

func submit () -> void:
	if line_edit.text == password:
		show_correct()
		show_success_timer.start()
	else:
		clear_input()
		show_failure()
		show_failure_timer.start()

func clear_input() -> void:
	line_edit.text = ""

func hide_failure() -> void:
	incorrect.hide()

func show_failure() -> void:
	incorrect.show()
	error_noise.play()

func show_correct() -> void:
	incorrect.hide()
	correct.show()
	success_noise.play()

func _ready() -> void:
	close_button.pressed.connect(quit_game)
	submit_button.pressed.connect(submit)
	clear_button.pressed.connect(clear_input)
	
	show_success_timer.timeout.connect(success_timer_timeout)
	show_failure_timer.timeout.connect(hide_failure)

func success_timer_timeout () -> void:
	on_win()
