extends Node3D

@export var left_door: Node3D
@export var right_door: Node3D
@export var inner_left_door: Node3D
@export var inner_right_door: Node3D

var left_closed_pos = Vector3.ZERO
var right_closed_pos = Vector3.ZERO
var left_open_pos = Vector3.ZERO
var right_open_pos = Vector3.ZERO

var inner_left_closed_pos = Vector3.ZERO
var inner_right_closed_pos = Vector3.ZERO
var inner_left_open_pos = Vector3.ZERO
var inner_right_open_pos = Vector3.ZERO

func _ready():
	left_closed_pos = left_door.position
	right_closed_pos = right_door.position
	inner_left_closed_pos = inner_left_door.position
	inner_right_closed_pos = inner_right_door.position
	
	left_open_pos = left_closed_pos + Vector3(0, 0, -1.2)
	right_open_pos = right_closed_pos + Vector3(0, 0, 1.2)
	
	inner_left_open_pos = inner_left_closed_pos + Vector3(0, 0, -1.2)
	inner_right_open_pos = inner_right_closed_pos + Vector3(0, 0, 1.2)

func _on_area_3d_body_entered(body):
	print(body.name)
	if body.name == 'Player':
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(left_door, 'position', left_open_pos, 1.0)
		tween.tween_property(right_door, 'position', right_open_pos, 1.0)
		tween.tween_property(inner_left_door, 'position', inner_left_open_pos, 1.0)
		tween.tween_property(inner_right_door, 'position', inner_right_open_pos, 1.0)

func _on_area_3d_body_exited(body):
	if body.name == 'Player':
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(left_door, 'position', left_closed_pos, 1.0)
		tween.tween_property(right_door, 'position', right_closed_pos, 1.0)
		tween.tween_property(inner_left_door, 'position', inner_left_closed_pos, 1.0)
		tween.tween_property(inner_right_door, 'position', inner_right_closed_pos, 1.0)
