extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_level():
	$Tilemap/Blacksmith.start_level()

func end_level():
	$Tilemap/Blacksmith.end_level()

func pause():
	$Tilemap/Blacksmith.pause_game()

func unpause():
	$Tilemap/Blacksmith.resume_game()
