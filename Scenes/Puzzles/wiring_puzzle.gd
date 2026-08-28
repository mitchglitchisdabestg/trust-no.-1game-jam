extends Control

var selected_socket: Button = null
var correct_wire: int = 0
const connections: int = 4

@onready var Leftsocket: Node = $"Leftsocket"
@onready var Rightsocket: Node = $"Rightsocket"
@onready var wires_container: Node = $Wires
@onready var completed_label: Label = $"Completed label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
