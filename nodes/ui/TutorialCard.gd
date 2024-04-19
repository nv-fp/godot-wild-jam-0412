extends Node2D

signal start

# Called when the node enters the scene tree for the first time.
func setup(tut_type: Enums.TutorialCard):
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
	if InputUtil.is_click(event):
		start.emit()
