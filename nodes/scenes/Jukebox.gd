extends Node

var playing: bool = false

var title_music = preload('res://sound/Proliferated_Edge.ogg')
var bg_music_0 = preload('res://sound/Valley_of_the_Flameseekers.ogg')
var bg_music_1 = preload('res://sound/A_Song_for_Ale.ogg')
var bg_music_2 = preload('res://sound/In_A_Rush_Demo-95bpm.mp3')
var credit_music = preload('res://sound/Meet_Me_At_The_End_Demo.mp3')

var order_fill = preload('res://sound/OrderSuccess.mp3')
var order_fail = preload('res://sound/OrderFailed.mp3')
var menu_accept = preload('res://sound/Anvil.mp3')
var turn_page = preload('res://sound/page_turn.mp3')

var cur_music = null

var player
var fx_player

func get_player():
	return player

func get_player_fx():
	return fx_player

func _ready():
	player = AudioStreamPlayer.new()
	player.playing = false
	player.autoplay = false
	player.stream_paused = false
	player.bus = 'BackgroundMusic'
	player.volume_db = -10.0

	fx_player = AudioStreamPlayer2D.new()
	fx_player.playing = false
	fx_player.autoplay = false
	fx_player.stream_paused = false
	fx_player.bus = 'HudFX'

func pause():
	player.stream_paused = true

func unpause():
	player.stream_paused = false

func play_bg(level: int):
	match level:
		0:
			_switch_to(bg_music_0);
		1:
			_switch_to(bg_music_1);
		2:
			_switch_to(bg_music_2);

func play_title():
	_switch_to(title_music)

func play_credits():
	_switch_to(credit_music)

func play_fx(fx: Enums.HudFX):
	var stream
	match fx:
		Enums.HudFX.ORDER_SUCCES:
			stream = order_fill
		Enums.HudFX.ORDER_FAIL:
			stream = order_fail
		Enums.HudFX.MENU_ACCEPT:
			stream = menu_accept
		Enums.HudFX.PAGE_TURN:
			stream = turn_page
		_:
			assert(false)
	fx_player.stream = stream
	fx_player.play()
	

func seek(to: float):
	if cur_music == null:
		return
	player.seek(to)

func _switch_to(new_stream):
	if cur_music == new_stream:
		return
	else:
		cur_music = new_stream
	player.stream = cur_music
	player.play()
