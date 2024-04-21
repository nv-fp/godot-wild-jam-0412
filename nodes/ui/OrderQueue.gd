extends Node2D

# Array<WantBubble>
var queue = []

@export var max_queue_size = 3

var _h_offset = 190

func pause():
	for wb in queue:
		if wb != null:
			wb.pause()

func unpause():
	for wb in queue:
		if wb != null:
			wb.unpause()

func get_size() -> int:
	return queue.size()

func fill(typ: String) -> bool:
	var item_id = find_item(typ)
	if item_id == null:
		return false
	var idx = get_item_idx(item_id)
	var wb = queue[idx]
	Jukebox.play_fx(Enums.HudFX.ORDER_SUCCES)
	wb.fill()
	return true

# given an item type find a match that has the lowest remaining time and return the string
# returns null if no matches found
func find_item(typ: String):
	var options = []
	for e in queue:
		if e.item_type == typ:
			options.push_back(e)
	if options.size() == 0:
		return null

	options.sort_custom(func(a, b): return a.remaining_time_ms() < b.remaining_time_ms())

	return options[0].id

# returns ?int
func get_item_idx(id: String):
	var idx = 0
	for e in queue:
		if e.id == id:
			return idx
		idx += 1
	return null

# returns ?WantBubble
func remove_item(id: String):
	if queue.size() == 0:
		return

	var idx = get_item_idx(id)
	if idx == null:
		return
	idx = idx as int # for the type checker
	var tgt = queue[idx]
	queue[idx] = null

	# can't remove yet in case we want to do any tweening
	_reflow(idx, tgt)
	
	return tgt

func has_space() -> bool:
	return queue.size() < max_queue_size

func add_item(wb: WantBubble) -> bool:
	if queue.size() == max_queue_size:
		return false

	wb.auto_free = false
	queue.push_back(wb)

	add_child(wb)
	wb.timeout.connect(_item_timeout)
	wb.completed.connect(_item_filled)
	_reflow(queue.size() - 1, wb)

	return true

func _item_timeout(id: String):
	Jukebox.play_fx(Enums.HudFX.ORDER_FAIL)
	remove_item(id)

func _item_filled(id: String, _points: int, _remaining_ms: int):
	remove_item(id)

#@export_enum('vertical', 'horizontal')
func _get_coords_pos(idx: int) -> Vector2:
	#var v_offset = 100
	return Vector2(0, idx * _h_offset)

func _reflow(idx: int, tgt: WantBubble):
	if queue[idx] == null:
		# remove the null place holder
		queue.remove_at(idx)
		# we may want to tween eventually but for now remove the child / free it
		remove_child(tgt)
		tgt.queue_free()
		for n in range(0, queue.size()):
			var p = _get_coords_pos(n)
			queue[n].position = Vector2(p.x, p.y)
	else:
		var p = _get_coords_pos(idx)
		tgt.position = Vector2(p.x, p.y)
