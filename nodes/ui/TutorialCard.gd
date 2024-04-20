extends Node2D

signal start

var _has_started = false

# Called when the node enters the scene tree for the first time.
func setup(tut_type: Enums.TutorialCard):
	_has_started = false
	$Background/Shield.visible = false
	$Background/Sword.visible = false
	$Background/Staff.visible = false
	match tut_type:
		Enums.TutorialCard.SHIELD:
			$Background/Shield.visible = true
		Enums.TutorialCard.SWORD:
			$Background/Sword.visible = true
		Enums.TutorialCard.STAFF:
			$Background/Staff.visible = true

func _text_button_enter(which: Label):
	which.modulate = Color.RED

func _text_button_exit(which: Label):
	which.modulate = Color.WHITE

func _start_enter():
	_text_button_enter($Start)

func _start_exit():
	_text_button_exit($Start)

func _start_event(_viewport, event, _shape_idx):
	if _has_started:
		return
	if InputUtil.is_click(event):
		start.emit()

func _process(_delta):
	if InputUtil.ui_accept() and not _has_started:
		start.emit()
