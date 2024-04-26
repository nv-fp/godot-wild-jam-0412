extends Node2D

# fires if the user wants to go to the next level or retry
#    (Enums.ProgressType)
signal progress

# fires if the user wants to head back to the main menu
signal to_menu

# how many hammers did the player achieve
var _hammer_count = 0

# should the next level be credits?
var _credits_next = false

# how many clicks on buttons have we tracked, we only get one
var _click_count = 0

func _get_message() -> Label:
	match _hammer_count:
		1:
			return $Message/LevelComplete
		2:
			return $Message/Wow
		3:
			return $Message/HammerTime
	return $Message/GoodTry

func _get_hammer(min: int) -> Texture2D:
	if _hammer_count >= min:
		return preload('res://art/level-summary/full-hammer.png')
	return preload('res://art/level-summary/empty-hammer.png')

func setup(level: int, score: int, score_limits: Array, orders_filled: int, orders_missed: int):
	_hammer_count = 0
	_click_count = 0
	for tgt in score_limits:
		if score > tgt:
			_hammer_count += 1

	$Score/Hammer1.texture = _get_hammer(1)
	$Score/Hammer2.texture = _get_hammer(2)
	$Score/Hammer3.texture = _get_hammer(3)

	$Stats/Score/Text.text = str(score)
	$Stats/Failures/Text.text = str(orders_missed)

	# TODO: having to do this is a mistake
	var save_level = level + 1
	var has_played = SaveData.has_played(save_level)
	var high_score = 0
	if has_played:
		var old_high_score = SaveData.get_high_score(save_level)
		if old_high_score > score:
			high_score = old_high_score

	if high_score < score:
		SaveData.record_level(save_level, score, _hammer_count)

	for c in $Message.get_children():
		c.visible = false
	_get_message().visible = true

	if _hammer_count < 1:
		$Buttons/Next.modulate = Color.GRAY
	else:
		$Buttons/Next.modulate = Color.WHITE

var _highlight_color = Color(1, 0.9, 0.9)
func _text_button_enter(which: Sprite2D):
	which.modulate = _highlight_color

func _text_button_exit(which: Sprite2D):
	which.modulate = Color.WHITE

func _progress_enter():
	if _hammer_count > 0:
		_text_button_enter($Buttons/Next)

func _progress_exit():
	if _hammer_count > 0:
		_text_button_exit($Buttons/Next)

func _progress_event(_viewport, event, _shape_idx):
	if not InputUtil.is_click(event):
		return

	# only one option
	if _click_count > 0:
		return

	if _hammer_count < 1:
		# Can't progress if we didn't win the level
		return

	_click_count = 1

	if _credits_next:
		progress.emit(Enums.ProgressType.CREDITS)
	else:
		progress.emit(Enums.ProgressType.NEXT_LEVEL)

func _menu_enter():
	_text_button_enter($Buttons/Menu)

func _menu_exit():
	_text_button_exit($Buttons/Menu)

func _menu_event(viewport, event, shape_idx):
	if _click_count > 0:
		return

	if InputUtil.is_click(event):
		_click_count = 1
		to_menu.emit()

func _retry_enter():
	_text_button_enter($Buttons/Retry)

func _retry_exit():
	_text_button_exit($Buttons/Retry)

func _retry_event(_viewport, event, _shape_idx):
	if _click_count > 0:
		return
	
	if InputUtil.is_click(event):
		_click_count = 1
		progress.emit(Enums.ProgressType.RETRY)
