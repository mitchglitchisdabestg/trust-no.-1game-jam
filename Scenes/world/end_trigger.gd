extends Area3D

@export var animation_player: AnimationPlayer

var triggered = false

func _on_body_entered1(body):
	print("IT WORKED!")
	
func _on_body_entered(body):
	print("TRIGGER ENTERED: ", body.name)

	if body.name == "Player" and not triggered:
		triggered = true
		print("PLAYING CUTSCENE!")
		animation_player.play("end_cutscene")
