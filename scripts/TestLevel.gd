extends Node2D

@onready var character = $TileMap2/Blacksmith
@onready var tilemap = $TileMap2


# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = character.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.position = character.position
	pass
