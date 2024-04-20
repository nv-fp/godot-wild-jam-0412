extends Node

var playing: bool = false

var bg_music = preload('res://sound/In_A_Rush_Demo-95bpm.mp3')
var title_music = preload('res://sound/Proliferated_Edge.ogg')
var credit_music = preload('res://sound/Meet_Me_At_The_End_Demo.mp3')

var cur_music = null

var player

func get_player():
	return player

func _ready():
	player = AudioStreamPlayer.new()
	player.playing = false
	player.autoplay = false
	player.stream_paused = false
	player.bus = 'BackgroundMusic'
	player.volume_db = -10.0

func pause():
	player.stream_paused = true

func unpause():
	player.stream_paused = false

func play_bg():
	_switch_to(bg_music)

func play_title():
	_switch_to(title_music)

func play_credits():
	_switch_to(credit_music)

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
	player.playing = true
