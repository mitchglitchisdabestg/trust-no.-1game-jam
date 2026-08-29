extends Puzzle

var selected_socket: Socket = null
var correct_wire: int = 0
const connections: int = 4

@onready var left_socket: Node = $"LeftSocket"
@onready var right_socket: Node = $"RightSocket"
@onready var wires_container: Node = $Wires
@onready var completed_label: Label = $"CompletedLabel"

@onready var wires: Dictionary[String,Line2D]

@onready var left_sockets: Array[Node] = left_socket.get_children()
@onready var right_sockets: Array[Node] = right_socket.get_children()

func _ready() -> void:
	reset_game()
	for socket: Socket in left_sockets:
		socket.socket_pressed.connect(on_socket_pressed)
	
	for socket: Socket in right_sockets:
		socket.socket_pressed.connect(on_socket_pressed)

func reset_game() -> void:
	wires = {} #Clear it all!
	
	for wire in wires_container.get_children():
		wire.points = []
		wires[wire.name] = wire
	

func on_socket_pressed(socket_pressed: Socket) -> void:
	if !selected_socket: # No socket is already selected
		selected_socket = socket_pressed
	elif selected_socket != socket_pressed and socket_pressed.socket_colour == selected_socket.socket_colour and wires.has(socket_pressed.socket_colour): # A socket is already selected, check for a match
		#Success! If we got this far, it's a match! Time to wire it up.
		var needed_wire: Line2D = wires[socket_pressed.socket_colour]
		needed_wire.add_point(selected_socket.global_position - Vector2(170,30))
		needed_wire.add_point(socket_pressed.global_position - Vector2(170,30))
		
		wires.erase(socket_pressed.socket_colour)
		selected_socket = null
	else:
		#If we got this far, it's not a match :(
		selected_socket = null
	
	if wires == {}: #All needed wires have been used
		on_win()
