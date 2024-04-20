extends Node2D

signal end_credits

var speed = 175

func _anim(dir: String):
	$Blacksmith.play(dir)

func _stop():
	$Blacksmith.stop()

var _bs_tween

var scr = [
	func(): _anim('east'),
	3000,
	func(): _anim('south_east'),
	250,
	func(): _anim('south'),
	100,
	func(): _anim('idle_south'),
	func(): _stop(),
	500,
	func(): _speak(blurb[0]),
	750,
	func(): _speak(blurb[1]),
]

var blurb = [
	"Hi there",
	"We're Team Dinos and wanted to thank\nyou for playing our game.",
]

func _speak_clear():
	$Dialoge/Text.text = ''

func _speak(contents):
	if contents == null:
		$Dialoge.visible = false
		return
	$Dialoge.visible = true
	$Dialoge/Text.text += '\n' + contents

func _get_velocity():
	if not $Blacksmith.is_playing():
		return Vector2(0, 0)

	var anim = $Blacksmith.get_animation()
	var x = 0
	var y = 0

	match anim:
		'east':
			x = 1
		'south':
			y = 1
		'south_east':
			x = 1
			y = 1
		'north':
			y = -1
		'north_east':
			x = 1
			y = -1
		_:
			x = 0
			y = 0
	
	return Vector2(x, y).normalized() * speed

var frame_pointer = 0
var _start_credits_ms

# Called when the node enters the scene tree for the first time.
func _ready():
	_start_credits_ms = Time.get_ticks_msec()
	Jukebox.play_credits()

	_bs_tween = get_tree().create_tween()
	
	_anim('east')

var _advance_at = 0
func _process_script():
	if frame_pointer >= scr.size():
		return
	var now = Time.get_ticks_msec()
	if now < _advance_at:
		return

	var thing = scr[frame_pointer]
	match typeof(thing):
		TYPE_INT:
			_advance_at = now + thing
		TYPE_CALLABLE:
			thing.call()

	frame_pointer += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		#end_credits.emit()
		get_tree().quit()

	_process_script()	
	var vel = _get_velocity()
	$Blacksmith.position += (delta * vel)
