extends Node2D

# Array[[String, Sprite2D]]
var components = []

@export var bubble_spacing = 4
@export var circle_radius = 8
@export var circle_bg_color = Color.GRAY

var _center = 0
var _left = 1
var _right = 2
func _get_pos_x(type: int) -> int:
	if type == _center:
		return position.x
	if type == _left:
		return position.x - circle_radius - (bubble_spacing / 2)
	if type == _right:
		return position.x + circle_radius + (bubble_spacing / 2)
	assert(false)
	return -1

func _get_pos_y(lvl: int) -> int:
	return position.y - (lvl * (2 * (circle_radius + bubble_spacing/2)))

func _draw():
	var count = components.size()
	if count == 0:
		return
	components.sort_custom(func(a, b): return a[0] < b[0])
	
	var lvl = 0
	var cur_position = _right
	for idx in range(0, count - 1):
		var mat_center = Vector2(_get_pos_x(cur_position), _get_pos_y(lvl))
		draw_circle(mat_center, circle_radius, circle_bg_color)
		var s = components[idx][1]
		s.position = mat_center

		match cur_position:
			_left:
				cur_position = _right
			_right:
				cur_position = _left

		#if cur_position == _left:
			#cur_position = _right
		#elif cur_position == _right:
			#cur_position = _left

		if idx > 0 and idx % 2 == 1:
			lvl += 1

	var last = _left
	if count % 2 == 1:
		last = _center
	
	var mat_center = Vector2(_get_pos_x(last), _get_pos_y(lvl))
	draw_circle(mat_center, circle_radius, circle_bg_color)
	components[count - 1][1].position = mat_center
	
# adds a new toast icon
# comes preloaded with toast_<materail> via atlas.cfg but generally
# can use anything accessible via WantBubbleFactory.get_tex
func add_material(type: String):
	var node = Sprite2D.new()
	node.texture = WantBubbleFactory.get_tex(type)
	add_child(node)
	components.push_back([type, node])
	queue_redraw()

# removes all materials
func clear():
	for c in components:
		remove_child(c[1])
	components.clear()
	queue_redraw()

func _add_random():
	var mats = [
		'toast_bronze',
		'toast_leather',
		'toast_wood',
		'toast_gold',
		'toast_diamond',
	]
	add_material(mats.pick_random())
