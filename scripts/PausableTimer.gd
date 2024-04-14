extends Node

@export var autostart: bool = true
@export var run_time_sec: float = 1.0

# milliseconds at timer start
var start_time_ms: int

# how long have we spent paused
var paused_time_ms: int = 0

# when did we pause
var pause_start_time_ms: int = 0

# fires if we hit the run_time
signal timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	if autostart:
		start()

func is_started() -> bool:
	return start_time_ms > 0

func is_paused() -> bool:
	return pause_start_time_ms > 0

func start() -> void:
	if not is_started():
		# first start
		start_time_ms = Time.get_ticks_msec()
	elif is_paused():
		var now = Time.get_ticks_msec()
		# resume
		paused_time_ms += now - pause_start_time_ms
		pause_start_time_ms = 0
	else:
		print("errant call to start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_started():
		return
	if is_paused():
		return

	var now = Time.get_ticks_msec()
	var passed_ms = (now - start_time_ms) - paused_time_ms
	
	if passed_ms > run_time_sec * 1000:
		timeout.emit()
	
