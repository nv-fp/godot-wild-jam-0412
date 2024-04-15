extends CanvasLayer

func start_level(time_sec: int):
	$TimeDisplay.set_time(time_sec)
	$TimeDisplay.start()

func update_score(value: int):
	$Score.update_score(value)

func pause():
	$TimeDisplay.pause()

func unpause():
	$TimeDisplay.unpause()
