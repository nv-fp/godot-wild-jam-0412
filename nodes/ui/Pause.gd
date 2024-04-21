extends Node2D

signal resume
signal menu
signal restart

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var _has_clicked = false

func setup():
	_has_clicked = false

var _highlight_color = Color(1, .9, .9)
func _button_enter(obj):
	if _has_clicked:
		return
	obj.modulate = _highlight_color

func _button_exit(obj):
	obj.modulate = Color.WHITE

func _resume_enter():
	_button_enter($Frame/Resume)

func _resume_exit():
	_button_exit($Frame/Resume)

func _resume_event(viewport, event, shape_idx):
	if _has_clicked:
		return
	if InputUtil.is_click(event):
		_has_clicked = true
		resume.emit()

func _retry_enter():
	_button_enter($Frame/Retry)

func _retry_exit():
	_button_exit($Frame/Retry)

func _retry_event(viewport, event, shape_idx):
	if _has_clicked:
		return
	if InputUtil.is_click(event):
		_has_clicked = true
		restart.emit()

func _menu_enter():
	_button_enter($Frame/Menu)

func _menu_exit():
	_button_exit($Frame/Menu)

func _menu_event(viewport, event, shape_idx):
	if _has_clicked:
		return
	if InputUtil.is_click(event):
		_has_clicked = true
		menu.emit()
