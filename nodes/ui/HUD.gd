extends CanvasLayer

@export var initial_display_sec: int = 180

func start_level():
	$TimeDisplay.start()

func update_score(value: int):
	$Score.update_score(value)

func pause():
	$TimeDisplay.pause()

func unpause():
	$TimeDisplay.unpause()

func _ready():
	$TimeDisplay.set_time(initial_display_sec)
	var p = Jukebox.get_player()
	add_child(p)

	Jukebox.play_bg()
	pass

func _exit_tree():
	remove_child(Jukebox.get_player())

func _toggle_audio(toggled_on):
	if toggled_on:
		$"Trash-bg/AudioToggle".icon = preload('res://art/no-audio.png')
		Jukebox.pause()
	else:
		$"Trash-bg/AudioToggle".icon = preload('res://art/audio-64.png')
		Jukebox.unpause()


func _background_pressed():
	Jukebox.play_bg()

func _title_pressed():
	Jukebox.play_title()
