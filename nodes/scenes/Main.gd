extends Node2D

@export var level_items = [
	'bronze_sword',
	'bronze_shield',
	'gold_sword',
	'gold_shield',
	'diamond_sword',
	'diamond_shield'
]

# Called when the node enters the scene tree for the first time.
func start_level():
	$Hud.visible = true
	$Hud.start_level(level_items)
