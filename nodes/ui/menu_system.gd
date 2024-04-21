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
	_intro_complete()

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

func _settings_enter():
	_over_button($MainMenuBG/SettingsButton)

func _settings_exit():
	_exit_button($MainMenuBG/SettingsButton)

func _settings_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		_load_settings()

func _load_settings():
	var t = get_tree().create_tween()
	var new_xy = $MainMenuBG.position
	new_xy.x += 1280
	t.set_parallel(true)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property($MainMenuBG, 'position', new_xy, 1.5)
	t.tween_property($SettingsMenu, 'position', Vector2.ZERO, 1.5)


func _unload_settings():
	var t = get_tree().create_tween()
	var new_xy = $SettingsMenu.position
	new_xy.x -= 1280
	t.set_parallel(true)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property($MainMenuBG, 'position', Vector2.ZERO, 1.5)
	t.tween_property($SettingsMenu, 'position', new_xy, 1.5)
