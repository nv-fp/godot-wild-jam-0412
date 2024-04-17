extends CanvasLayer

@export var initial_display_sec: int = 180

func start_level():
	$TimeDisplay.start()

func update_score(value: int):
	$Score.update_score(value)

func _ready():
	$TimeDisplay.set_time(initial_display_sec)
	var p = Jukebox.get_player()
	add_child(p)

	Jukebox.play_bg()

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

func _on_button_pressed():
	var item = $OrderQueue.queue[0]
	$OrderQueue.remove_item(item.id)

func _on_button_2_pressed():
	var item = $OrderQueue.queue[1]
	$OrderQueue.remove_item(item.id)

func _on_button_3_pressed():
	var item = $OrderQueue.queue[2]
	$OrderQueue.remove_item(item.id)

func _on_button_4_pressed():
	var wb = WantBubbleFactory.new_item(null)
	wb.completed.connect(_item_completed)
	wb.timeout.connect(_item_missed)
	$OrderQueue.add_item(wb)

func _item_completed(id: String, points: int, remaining_ms: int):
	var wb_idx = $OrderQueue.get_item_idx(id)
	var wb = $OrderQueue.queue[wb_idx]
	var percent = clampf(remaining_ms / (.75 * wb.complete_time_ms), 0, 1.0)
	update_score((percent * points) as int)
	$OrderQueue.remove_item(id)

func _item_missed(_id: String):
	update_score(-50)

func pause():
	$OrderQueue.pause()
	$TimeDisplay.pause()

func unpause():
	$OrderQueue.unpause()
	$TimeDisplay.unpause()

func _toggle_pause(toggled_on):
	if toggled_on:
		$Button5.text = 'Unpause'
		pause()
	else:
		$Button5.text = 'Pause'
		unpause()

func _button(typ: String):
	$OrderQueue.fill(typ)

func _bsword():
	_button('bronze_sword')
func _bshield():
	_button('bronze_shield')
func _bstaff():
	_button('bronze_staff')
func _dsword():
	_button('diamond_sword')
func _dshield():
	_button('diamond_shield')
func _dstaff():
	_button('diamond_staff')
func _gsword():
	_button('gold_sword')
func _gshield():
	_button('gold_shield')
func _gstaff():
	_button('gold_staff')
