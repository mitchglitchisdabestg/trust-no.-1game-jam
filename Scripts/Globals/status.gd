extends Node

enum Statuses {World,Puzzle}

var current_status: Statuses = Statuses.World

var stored_casette_stream: AudioStream = null

func set_status(new_status: Statuses) -> void:
	current_status = new_status

func set_stored_casette_stream (stream: AudioStream) -> void:
	stored_casette_stream = stream
