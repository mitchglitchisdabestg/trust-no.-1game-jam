extends Puzzle

var selected_socket: Socket = null
var correct_wire: int = 0
const connections: int = 4

@onready var left_socket: VBoxContainer = $Main_Panel/LeftSocket
@onready var right_socket: VBoxContainer = $Main_Panel/RightSocket
@onready var wires_container: Control = $Main_Panel/Wires
@onready var completed_label: Label = $Main_Panel/CompletedLabel

@onready var wires: Dictionary[String,Line2D]

@onready var left_sockets: Array[Node] = left_socket.get_children()
@onready var right_sockets: Array[Node] = right_socket.get_children()

@onready var close_button: Button = $CloseButton
@onready var show_success_timer: Timer = $ShowSuccessTimer

@onready var wire_success: AudioStreamPlayer = $WireSuccess
@onready var press_2: AudioStreamPlayer = $Press2
@onready var electric_fail: AudioStreamPlayer = $ElectricFail

func _ready() -> void:
	Status.set_status(Status.Statuses.Puzzle)
	reset_game()
	
	for socket: Socket in left_sockets:
		socket.socket_pressed.connect(on_socket_pressed)
	
	for socket: Socket in right_sockets:
		socket.socket_pressed.connect(on_socket_pressed)
	
	close_button.pressed.connect(quit_game)
	show_success_timer.timeout.connect(on_success_timeout)

func reset_game() -> void:
	wires = {} #Clear it all!
	
	for wire in wires_container.get_children():
		wire.points = []
		wires[wire.name] = wire

func on_success_timeout() -> void: # Lets people admire their completed puzzle for a bit :D
	super.on_win()
	quit_game()

func on_socket_pressed(socket_pressed: Socket) -> void:
	
	if !selected_socket or selected_socket == socket_pressed: # No socket is already selected
		selected_socket = socket_pressed
		press_2.play()
	elif selected_socket != socket_pressed and socket_pressed.socket_colour == selected_socket.socket_colour and wires.has(socket_pressed.socket_colour): # A socket is already selected, check for a match
		#Success! If we got this far, it's a match! Time to wire it up.
		var needed_wire: Line2D = wires[socket_pressed.socket_colour]
		needed_wire.add_point(selected_socket.global_position - Vector2(170,30))
		needed_wire.add_point(socket_pressed.global_position - Vector2(170,30))
		
		wire_success.play()
		
		wires.erase(socket_pressed.socket_colour)
		selected_socket = null
	else:
		#If we got this far, it's not a match :(
		electric_fail.play()
		selected_socket = null
	
	if wires == {}: #All needed wires have been used
		on_win()

func on_win() -> void:
	show_success_timer.start()
