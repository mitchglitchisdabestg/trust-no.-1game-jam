extends TextureRect

func _process(_delta: float) -> void:
	var random_x = randi_range(-300, -50)
	var random_y = randi_range(-150, 150)
	position = Vector2(random_x, random_y)
