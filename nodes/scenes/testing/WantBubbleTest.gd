extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _bubble_trigger(id: String) -> void:
	print('triggered timeout on ', id)

var _want_bubble
func has_bubble() -> bool:
	return _want_bubble != null

func add_bubble():
	if has_bubble():
		return
	
	_want_bubble = WantBubbleFactory.new_item(null)
	_want_bubble.id = 'whee'
	var tgt_rect = $TestPc/Sprite2D.get_rect()
	_want_bubble.position.y -= ((tgt_rect.size.y / 2) + 10)
	_want_bubble.timeout.connect(_bubble_timeout)
	_want_bubble.completed.connect(_bubble_filled)
	$TestPc.add_child(_want_bubble)

func fill_bubble():
	if not has_bubble():
		return
	_want_bubble.fill()

func _bubble_timeout(id: String) -> void:
	if has_bubble():
		print('want missed: ', id)
		_want_bubble.queue_free()
		_want_bubble = null

func _bubble_filled(id: String, value: int) -> void:
	if has_bubble():
		print('want fulfilled: ', id, ' for points: ', value)
		_want_bubble.queue_free()
		_want_bubble = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		add_bubble()
	
	if Input.is_action_just_pressed('ui_cancel'):
		fill_bubble()

	if Input.is_action_just_pressed('ui_focus_next'):
		get_tree().quit()

