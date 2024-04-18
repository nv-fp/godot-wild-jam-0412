extends Node2D

# fires if the user wants to go to the next level or retry
#    (Enums.ProgressType)
signal progress

# fires if the user wants to head back to the main menu
signal to_menu

var _hammer_count = 0

func _get_message() -> String:
	match _hammer_count:
		1:
			return 'Level Complete!'
		2:
			return 'Wow, good job!'
		3:
			return "It's hammer time!"
	return 'Good Try!'

func _get_progress_text() -> String:
	if _hammer_count > 0:
		return 'Next Level >'
	return 'Retry'

func _get_hammer(min: int) -> Texture2D:
	if _hammer_count >= min:
		return preload('res://art/level-summary/full-hammer.png')
	return preload('res://art/level-summary/empty-hammer.png')

func setup(score: int, score_limits: Array):
	_hammer_count = 0
	for tgt in score_limits:
		if score > tgt:
			_hammer_count += 1

	$Score/Hammer1.texture = _get_hammer(1)
	$Score/Hammer1.texture = _get_hammer(2)
	$Score/Hammer1.texture = _get_hammer(3)

	$Message.text = _get_message()
	$Progress.text = _get_progress_text()

func _text_button_enter(which: Label):
	which.modulate = Color.RED

func _text_button_exit(which: Label):
	which.modulate = Color.WHITE

func _progress_enter():
	_text_button_enter($Progress)

func _progress_exit():
	_text_button_exit($Progress)

func _progress_event(_viewport, event, _shape_idx):
	if not InputUtil.is_click(event):
		return

	if _hammer_count > 0:
		progress.emit(Enums.ProgressType.NEXT_LEVEL)
	else:
		progress.emit(Enums.ProgressType.RETRY)

func _menu_enter():
	_text_button_enter($Menu)

func _menu_exit():
	_text_button_exit($Menu)

func _menu_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		to_menu.emit()
