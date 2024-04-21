extends Node2D

signal start

var _has_started = false
var _cur_page = -1
var _max_page = -1

func _ready():
	setup(Enums.TutorialCard.STAFF)

# Called when the node enters the scene tree for the first time.
func setup(tut_type: Enums.TutorialCard):
	_has_started = false
	match tut_type:
		Enums.TutorialCard.SHIELD:
			_cur_page = 0
			_max_page = 1
		Enums.TutorialCard.SWORD:
			_cur_page = 2
			_max_page = 2
		Enums.TutorialCard.STAFF:
			_cur_page = 3
			_max_page = 3
	update_pages()

var _highlight_color = Color(1, 0.9, 0.9)
func _text_button_enter(which):
	which.modulate = _highlight_color

func _text_button_exit(which):
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

func update_pages():
	$Background/Instructions.visible = false
	$Background/Shield.visible = false
	$Background/Sword.visible = false
	$Background/Staff.visible = false
	$Pagers/Left.visible = false
	$Pagers/Right.visible = false
	$Start.visible = false

	match _cur_page:
		0:
			$Background/Instructions.visible = true
		1:
			$Background/Shield.visible = true
		2:
			$Background/Sword.visible = true
		3:
			$Background/Staff.visible = true

	if _cur_page > 0:
		$Pagers/Left.visible = true
	if _cur_page < _max_page:
		$Pagers/Right.visible = true
	if _cur_page == _max_page:
		$Start.visible = true

func _enter_left():
	_text_button_enter($Pagers/Left)

func _exit_left():
	_text_button_exit($Pagers/Left)

func _left_event(viewport, event, shape_idx):
	if not InputUtil.is_click(event):
		return

	if _cur_page <= 0:
		return

	_cur_page -= 1
	Jukebox.play_fx(Enums.HudFX.PAGE_TURN)
	update_pages()

func _enter_right():
	_text_button_enter($Pagers/Right)

func _exit_right():
	_text_button_exit($Pagers/Right)

func _right_event(viewport, event, shape_idx):
	if not InputUtil.is_click(event):
		return

	if _cur_page >= _max_page:
		return
	_cur_page += 1
	Jukebox.play_fx(Enums.HudFX.PAGE_TURN)
	update_pages()
