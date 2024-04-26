extends Node2D

# emit when the back button is pressed
signal unload

# emit when a level is selected to play; comes with a value [1, 3]
# 	(level: int)
signal play_level

var cur_level = 1

var _has_selected_level = false
func setup():
	_has_selected_level = false
	load_scores()

func load_scores():
	for level_card in get_node('Carousel/Cards').get_children():
		var level = level_card.get_meta('level')
		var sb = level_card.get_node('ScoreBadge')
		sb.setup(level)

var _highlight_color = Color(1, .9, .9)

func _button_over(obj):
	obj.modulate = _highlight_color

func _button_exit(obj):
	obj.modulate = Color.WHITE

func _left_enter():
	_button_over($Carousel/Pagers/Left)

func _left_exit():
	_button_exit($Carousel/Pagers/Left)

func _page_to_obj(p):
	match p:
		1:
			return $Carousel/Cards/Level1
		2:
			return $Carousel/Cards/Level2
		3:
			return $Carousel/Cards/Level3

var width = 930 * .6

var tween
func _left_event(viewport, event, shape_idx):
	if not InputUtil.is_click(event):
		return

	if tween != null and tween.is_running():
		return

	tween = get_tree().create_tween()
	
	var old_page = _page_to_obj(cur_level)
	cur_level -= 1
	var new_page = _page_to_obj(cur_level)
	
	var oldx = $Carousel/Cards.position.x
	var newx = oldx + width
	var oldy = $Carousel/Cards.position.y
	
	Jukebox.play_fx(Enums.HudFX.PAGE_TURN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($Carousel/Cards, 'position', Vector2(newx, oldy), .75)
	tween.tween_property(old_page, 'modulate', Color(Color.WHITE, 0), .75)
	tween.tween_property(new_page, 'modulate', Color.WHITE, .75)
	
	update_pagers()

func update_pagers():
	$Carousel/Pagers/Left.visible = true
	$Carousel/Pagers/Right.visible = true
	if cur_level == 1:
		$Carousel/Pagers/Left.visible = false
	if cur_level == 3:
		$Carousel/Pagers/Right.visible = false

func _right_enter():
	_button_over($Carousel/Pagers/Right)

func _right_exit():
	_button_exit($Carousel/Pagers/Right)

func _right_event(viewport, event, shape_idx):
	if not InputUtil.is_click(event):
		return

	if tween != null and tween.is_running():
		return

	tween = get_tree().create_tween()
	var old_page = _page_to_obj(cur_level)
	cur_level += 1
	var new_page = _page_to_obj(cur_level)
	
	var oldx = $Carousel/Cards.position.x
	var newx = oldx - width
	var oldy = $Carousel/Cards.position.y
	
	Jukebox.play_fx(Enums.HudFX.PAGE_TURN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property($Carousel/Cards, 'position', Vector2(newx, oldy), .75)
	tween.tween_property(old_page, 'modulate', Color(Color.WHITE, 0), .75)
	tween.tween_property(new_page, 'modulate', Color.WHITE, .75)
	
	update_pagers()

func _unload_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		unload.emit()


func _back_enter():
	_button_over($Back)

func _back_exit():
	_button_exit($Back)

func _back_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		unload.emit()

func _play_enter():
	_button_over($Play)

func _play_exit():
	_button_exit($Play)

func _play_event(viewport, event, shape_idx):
	if not InputUtil.is_click(event) or _has_selected_level:
		return

	_has_selected_level
	play_level.emit(cur_level)
