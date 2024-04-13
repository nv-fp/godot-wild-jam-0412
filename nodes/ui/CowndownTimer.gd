extends Node2D

### TODO: It's plausible that use of _draw like this is going to cause problems
### if we dump too many of these on screen at once. TBD. I doubt we'll hit that
### in the jam but I don't know if it's uniquely bad since _draw didn't seem
### like a normal paved road to follow.

# how long should this count down
@export var run_time: float
var run_time_ms: float

@export var bg_color: Color = Color.WHITE
@export var fg_color_lots: Color = Color.DARK_GREEN
@export var fg_color_med: Color = Color.ORANGE
@export var fg_color_low: Color = Color.CRIMSON

# start as soon as it's added or wait for something
@export var autostart: bool = true

@export var radius: int = 10
@export var redraw_rate_ms: int = 10

# This is an id that will be provided with the timout signal, default to ""
@export var id: String = ""

# fires when countdown is completed
signal timeout

@onready var timer = $Timer
@onready var redraw_timer = $RedrawTimer

# milliseconds at timer start
var start_time_ms: int

# how long have we spent paused
var paused_time_ms: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if run_time == 0:
		run_time = 4

	run_time_ms = run_time * 1000
	timer.one_shot = true
	timer.wait_time = run_time

	redraw_timer.wait_time = redraw_rate_ms / 1000.0
	if autostart:
		start()

func _draw():
	var now: float = Time.get_ticks_msec()
	var progress: float = (now - start_time_ms - paused_time_ms) / run_time_ms

	var draw_color: Color = fg_color_lots
	if progress > .8:
		draw_color = fg_color_low
	elif progress > .5:
		draw_color = fg_color_med

	var draw_center = Vector2.ZERO

	draw_circle(draw_center, 2 * radius, bg_color)
	draw_arc(draw_center, radius, TAU, TAU * progress, radius + 1, draw_color, (2 * radius) + 1)

func is_started() -> bool:
	return start_time_ms > 0

func is_paused() -> bool:
	return pause_start_time_ms > 0

func start() -> void:
	if not is_started():
		# first start
		start_time_ms = Time.get_ticks_msec()
		timer.start()
		redraw_timer.start()
	elif is_paused():
		var now = Time.get_ticks_msec()
		# resume
		paused_time_ms += now - pause_start_time_ms
		pause_start_time_ms = 0
		timer.set_paused(false)
		redraw_timer.set_paused(false)
	else:
		print("errant call to start for: " , id)

var pause_start_time_ms: int = 0
func pause() -> void:
	if is_paused():
		return
	pause_start_time_ms = Time.get_ticks_msec()
	timer.set_paused(true)
	redraw_timer.set_paused(true)

func _on_timer_timeout():
	timeout.emit(id)
	queue_free()

func _on_redraw_timer_timeout():
	queue_redraw()
