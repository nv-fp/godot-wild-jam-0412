extends Node2D

# indicates we should start the game:
#     (Enums.StartMode, level_path: String)
# if starting in StartMode.SINGLE_LEVEL the level_path is the resource path for
# that level.
#
# if starting in StartMode.NORMAL level is an empty string
signal start_game
signal quit_game
signal show_credits

var has_displayed_intro_animation = false

func _ready():
	Jukebox.play_title()
	_start_intro()

var tweeners = []
func _start_intro():
	var start_start_xy = $MainMenuBG/StartButton.position
	$MainMenuBG/StartButton.position.y = -450

	var credits_start_xy = $MainMenuBG/CreditsButton.position
	$MainMenuBG/CreditsButton.position.y = -426

	var quit_start_xy = $MainMenuBG/QuitButton.position
	$MainMenuBG/QuitButton.position.y = -400

	var t_quit = get_tree().create_tween()
	t_quit.set_trans(Tween.TRANS_BOUNCE)
	t_quit.set_ease(Tween.EASE_OUT)
	t_quit.tween_property($MainMenuBG/QuitButton, 'position', quit_start_xy, 1.5)

	var t_credits = get_tree().create_tween()
	t_credits.set_trans(Tween.TRANS_BOUNCE)
	t_credits.set_ease(Tween.EASE_OUT)
	t_credits.tween_property($MainMenuBG/CreditsButton, 'position', $MainMenuBG/CreditsButton.position, .75)
	t_credits.tween_property($MainMenuBG/CreditsButton, 'position', credits_start_xy, 1.5)

	var t_start = get_tree().create_tween()
	t_start.set_trans(Tween.TRANS_BOUNCE)
	t_start.set_ease(Tween.EASE_OUT)
	t_start.tween_property($MainMenuBG/StartButton, 'position', $MainMenuBG/StartButton.position, 1.75)
	t_start.tween_property($MainMenuBG/StartButton, 'position', start_start_xy, 1.5)
	t_start.tween_callback(_intro_complete)

func _intro_complete():
	has_displayed_intro_animation = true

var _highlight_color = Color(1, 0.9, 0.9)

func _over_button(b: Sprite2D):
	if not has_displayed_intro_animation:
		return
	b.modulate = _highlight_color

func _exit_button(b: Sprite2D):
	b.modulate = Color.WHITE

func _start_over():
	_over_button($MainMenuBG/StartButton)

func _start_exit():
	_exit_button($MainMenuBG/StartButton)

func _start_input(_viewport, event: InputEvent, _shape_idx):
	if not has_displayed_intro_animation:
		return
	if InputUtil.is_click(event):
		start_game.emit()

func _quit_over():
	_over_button($MainMenuBG/QuitButton)

func _quit_exit():
	_exit_button($MainMenuBG/QuitButton)

func _quit_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		quit_game.emit()

func _over_credits():
	_over_button($MainMenuBG/CreditsButton)

func _exit_credits():
	_exit_button($MainMenuBG/CreditsButton)

func _action_credits(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		show_credits.emit()
