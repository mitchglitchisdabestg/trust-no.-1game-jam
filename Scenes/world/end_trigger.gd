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
		body.set_physics_process(false)
		await animation_player.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		
		get_tree().change_scene_to_file("res://Scenes/main_menu/main_menu.tscn")
