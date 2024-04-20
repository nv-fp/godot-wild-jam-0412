extends Node2D

signal end_credits

# Called when the node enters the scene tree for the first time.
func _ready():
	Jukebox.play_credits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		end_credits.emit()
