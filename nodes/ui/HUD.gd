extends CanvasLayer

@export var initial_display_sec: int = 180
@export var order_frequency_sec: int = 15

var _level_items

# Fires when the timer is done
#  (score: int, orders_filled: int, orders_missed: int)
signal level_completed

func start_level(level_items):
	visible = true
	_level_items = level_items
	$TimeDisplay.start()
	$OrderTimer.wait_time = order_frequency_sec
	$OrderTimer.start()
	# start with a new order
	_order_timer_triggered()

func _order_timer_triggered():
	if $OrderQueue.has_space():
		var new_want = WantBubbleFactory.new_item(_level_items)
		new_want.completed.connect(_item_completed)
		new_want.timeout.connect(_item_missed)
		$OrderQueue.add_item(new_want)

func update_score(value: int):
	$Score.update_score(value)

func _ready():
	$TimeDisplay.set_time(initial_display_sec)
	$OrderTimer.wait_time = order_frequency_sec

func _level_over():
	$OrderQueue.pause()
	$TimeDisplay.pause()
	$OrderTimer.set_paused(true)
	level_completed.emit($Score.cur_score, item_completed, item_missed)

#func _exit_tree():
	#remove_child(Jukebox.get_player())

func _toggle_audio(toggled_on):
	if toggled_on:
		$"Trash-bg/AudioToggle".icon = preload('res://art/no-audio.png')
		Jukebox.pause()
	else:
		$"Trash-bg/AudioToggle".icon = preload('res://art/audio-64.png')
		Jukebox.unpause()

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

var item_completed = 0
var item_missed = 0

func _item_completed(id: String, points: int, remaining_ms: int):
	item_completed += 1
	var wb_idx = $OrderQueue.get_item_idx(id)
	var wb = $OrderQueue.queue[wb_idx]
	var percent = clampf(remaining_ms / (.75 * wb.complete_time_ms), .2, 1.0)
	update_score((percent * points) as int)
	$OrderQueue.remove_item(id)

func _item_missed(_id: String):
	item_missed += 1
	update_score(-50)

func pause():
	$OrderQueue.pause()
	$TimeDisplay.pause()
	$OrderTimer.set_paused(true)

func unpause():
	$OrderQueue.unpause()
	$TimeDisplay.unpause()
	$OrderTimer.set_paused(false)

func _toggle_pause(toggled_on):
	if toggled_on:
		$DebugUI/Button5.text = 'Unpause'
		pause()
	else:
		$DebugUI/Button5.text = 'Pause'
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
