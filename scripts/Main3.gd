extends Node2D

@export var level_items = [
	'bronze_sword',
	'bronze_shield',
	'gold_sword',
	'gold_shield',
	'diamond_sword',
	'diamond_shield',
	'bronze_staff',
	'gold_staff',
	'diamond_staff',
]

@export var score_limits = [150, 600, 1100]

# Called when the node enters the scene tree for the first time.
func start_level():
	$Hud.visible = true
	$Hud.start_level(level_items)
	$Level.get_node('TileMap').start_level()
	_level_started = true

func end_level():
	$Level.get_node('TileMap').end_level()

func pause():
	$Hud.pause()
	$Level.get_node('TileMap').pause()

func unpause():
	$Hud.unpause()
	$Level.get_node('TileMap').unpause()

signal toggle_pause
var _level_started = false
func _process(_delta):
	if not _level_started:
		return
	if Input.is_action_just_pressed('ui_cancel'):
		print('Main3.toggle_pause.emit()')
		toggle_pause.emit()
