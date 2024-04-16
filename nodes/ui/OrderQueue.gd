extends Node2D

# Array<WantBubble>
var queue = []

func get_size() -> int:
	return queue.size()

func get_item(id: String):
	var idx = 0
	for e in queue:
		if e.id == id:
			return idx
		idx += 1
	return null

# returns ?WantBubble
func remove_item(id: String):
	print('removing: ' + id)
	if queue.size() == 0:
		return

	var idx = get_item(id)
	print('found at idx: ', idx)
	if idx == null:
		return
	idx = idx as int # for the type checker
	var tgt = queue[idx]
	queue[idx] = null

	# can't remove yet in case we want to do any tweening
	_reflow(idx, tgt)
	
	return tgt

func add_item(wb: WantBubble):
	wb.auto_free = false
	queue.push_back(wb)
	print('queue is now: ')
	for e in queue:
		print(e.id)
	print('')

	add_child(wb)
	wb.timeout.connect(_item_timeout)
	wb.completed.connect(_item_filled)
	_reflow(queue.size() - 1, wb)

func _item_timeout(id: String):
	remove_item(id)

func _item_filled(id: String, _points: int, _remaining_ms: int):
	remove_item(id)

func _get_coords_pos(idx: int) -> Vector2:
	return Vector2(idx * 74, 0)

func _reflow(idx: int, tgt: WantBubble):
	if queue[idx] == null:
		# remove the null place holder
		queue.remove_at(idx)
		# we may want to tween eventually but for now remove the child / free it
		remove_child(tgt)
		tgt.queue_free()
		print('Updated queue:')
		for n in range(0, queue.size()):
			print(queue[n].id)
			var p = _get_coords_pos(n)
			queue[n].position = Vector2(p.x, p.y)
		print('')
	else:
		var p = _get_coords_pos(idx)
		tgt.position = Vector2(p.x, p.y)
		#tgt.transform = Transform2D() # _get_coords_pos(idx)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
