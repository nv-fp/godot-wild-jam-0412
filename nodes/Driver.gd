extends Node2D

var menu_system
var cur_tweener
var active_level

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Jukebox.get_player())
	menu_system = preload('res://nodes/ui/menu_system.tscn').instantiate()
	add_child(menu_system)

	menu_system.start_game.connect(_game_start)
	menu_system.quit_game.connect(_game_exit)

func _game_exit():
	get_tree().quit()

func _game_start(typ: Enums.StartMode, level_path: String):
	match typ:
		Enums.StartMode.NORMAL:
			cur_tweener = get_tree().create_tween()
			cur_tweener.tween_property(
				$Curtain,
				"modulate",
				_color_fade_out,
				1.5)
			cur_tweener.tween_callback(_fade_out_completed)
			
		Enums.StartMode.SINGLE_LEVEL:
			print('wants to start ' + level_path)
		_:
			assert(false)

var _color_fade_out = Color(0, 0, 0, 1)
var _color_fade_in = Color(0, 0, 0, 0)
func _fade_out_completed():
	cur_tweener = null
	active_level = preload('res://nodes/scenes/Main.tscn').instantiate()
	#active_level.modulate = Color.BLACK
	add_child(active_level)
	menu_system.visible = false
	menu_system.modulate = Color.WHITE

	cur_tweener = get_tree().create_tween()
	cur_tweener.tween_property($Curtain, 'modulate', _color_fade_in, 1.5)
	cur_tweener.tween_property($Curtain, 'modulate', _color_fade_in, 1)
	cur_tweener.tween_callback(_level_fade_in_completed)
	Jukebox.play_bg()
	
func _level_fade_in_completed():
	cur_tweener = null
	active_level.start_level()

