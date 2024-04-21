extends Node2D

@export var level_items = [
	'bronze_shield',
	'gold_shield',
	'diamond_shield'
]

@export var score_limits = [150, 250, 500]

# Called when the node enters the scene tree for the first time.
func start_level():
	$Hud.visible = true
	$Hud.start_level(level_items)
	$Level.start_level()
	_level_started = true

func end_level():
	$Level.end_level()

func pause():
	$Hud.pause()
	$Level.pause()

func unpause():
	$Hud.unpause()
	$Level.unpause()

signal toggle_pause
var _level_started = false
func _process(_delta):
	if not _level_started:
		return
	if Input.is_action_just_pressed('ui_cancel'):
		print('Main1.toggle_pause.emit()')
		toggle_pause.emit()
