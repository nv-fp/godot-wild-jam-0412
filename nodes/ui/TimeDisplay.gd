extends Label

func start():
	if rem_time_sec == 0:
		# we've reached jam level error handling
		assert(false)
	$Timer.start()

var paused: bool = false

func pause():
	paused = true

func unpause():
	paused = false

var rem_time_sec: int = 0

func set_time(time_sec: int) -> void:
	rem_time_sec = time_sec
	update_digits()

func update_digits():
	var min = rem_time_sec / 60
	var sec = (rem_time_sec - min*60)
	
	var d3 = sec / 10
	var d4 = sec - d3 * 10
	
	$Digit2.text = str(min)
	$Digit3.text = str(d3)
	$Digit4.text = str(d4)

func _ready():
	set_time(128)
	start()

func _tick():
	if paused:
		return
	if rem_time_sec == 0:
		$Timer.stop()
		return

	rem_time_sec -= 1
	update_digits()
