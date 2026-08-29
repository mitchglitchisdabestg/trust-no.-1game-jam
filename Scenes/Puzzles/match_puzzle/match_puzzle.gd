extends Control

var door_ID_to_open: int = 2222

@onready var close_button: Button = $CloseButton
@onready var show_success_timer: Timer = $ShowSuccessTimer
@onready var tiles_container: MarginContainer = $MainFrame/TilesContainer
@onready var failed_reveal_timer: Timer = $FailedRevealTimer

@onready var success_sound: AudioStreamPlayer = $Success
@onready var fail_sound: AudioStreamPlayer = $Fail
@onready var click_sound: AudioStreamPlayer = $Click

@export var rune_icon_uids: Array[String] # Currently gone up to R.tga DO NOT DELETE THIS LINE

var selected_rune: Rune = null # Set later, obviously
var failed_rune: Rune = null # For hiding it after a delay

var rune_icons: Array[CompressedTexture2D] = []

var runes_set_count: int = 0 # Will be set on reset() then decrease as players solve pairs
var rune_nodes: Array[Rune] = []
var chosen_rune_icons: Array[CompressedTexture2D] = []

func _ready() -> void:
	Status.set_status(Status.Statuses.Puzzle)
	# Attach tile signals
	for descendant: Node in tiles_container.find_children("*"):
		if !descendant is Rune: continue
		rune_nodes.append(descendant)
	
	for rune: Rune in rune_nodes:
		rune.rune_pressed.connect(on_rune_pressed)
	
	close_button.pressed.connect(quit_game)
	show_success_timer.timeout.connect(on_success_timeout)
	failed_reveal_timer.timeout.connect(on_failed_pair_timeout)
	
	reset_game()

func load_icons() -> void:
	rune_icons.clear()
	
	#Load potential images
	for UID: String in rune_icon_uids:
		rune_icons.append(load(UID))

func reset_game() -> void:
	load_icons()
	rune_icons.shuffle()
	
	var is_second_icon: bool = false # for alternating
	
	#Decide
	
	for rune: Rune in rune_nodes:
		if !rune_icons.front(): return
		
		if is_second_icon:
			chosen_rune_icons.append(rune_icons.pop_front())
			runes_set_count += 1
		else:
			chosen_rune_icons.append(rune_icons.front())
		
		is_second_icon = !is_second_icon
	
	chosen_rune_icons.shuffle()
	
	for rune: Rune in rune_nodes: # Set the icons and flip all to hidden
		rune.icon = chosen_rune_icons.pop_front()
		rune.hide_icon()
	

func on_rune_pressed(rune_pressed: Rune) -> void:
	if !failed_reveal_timer.is_stopped() or rune_pressed.rune_disabled: return # Stops spamming if you failed last time
	
	click_sound.play()
	rune_pressed.reveal_icon()
	
	if !selected_rune: # No rune is already selected
		selected_rune = rune_pressed
	elif selected_rune != rune_pressed and rune_pressed.icon == selected_rune.icon: # A rune is already selected, check for a match
		#Success! If we got this far, it's a match! Time to remove the tiles.
		selected_rune.rune_disabled = true
		rune_pressed.rune_disabled = true
		
		selected_rune = null
		runes_set_count -= 1
		success_sound.play()
	else:
		#If we got this far, it's not a match :(
		failed_reveal_timer.start()
		failed_rune = rune_pressed
	
	if runes_set_count == 0: #All runes have been hidden
		on_win()

func on_success_timeout() -> void: # Lets people admire their completed work for a bit :D
	SignalBus.emit_open_door(door_ID_to_open)
	quit_game()

func on_failed_pair_timeout() -> void:
	failed_rune.hide_icon()
	selected_rune.hide_icon()
	failed_rune = null
	selected_rune = null

func quit_game() -> void:
	Status.set_status(Status.Statuses.World)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func on_win() -> void:
	show_success_timer.start()
