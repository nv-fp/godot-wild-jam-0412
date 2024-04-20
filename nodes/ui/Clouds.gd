extends Node2D

@export var height = 720 / 3
@export var fast_clouds_vel = 1280 / 18
@export var slow_clouds_vel =  1280 / 23

@export var max_clouds = 12

var fast_clouds = []
var slow_clouds = []

var tex = [
	preload('res://art/credits/cloud1.png'),
	preload('res://art/credits/cloud2.png'),
	preload('res://art/credits/cloud3.png'),
]

var pool = []
var _max_x = 0

func _get_y() -> int:
	return position.y - randi_range(0, height)

func _on_screen(xy: Vector2) -> bool:
	var t = xy.x < (_max_x + 200) 
	return t

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_get_size()
	_max_x = get_viewport().get_visible_rect().size.x

	for x in range(0, max_clouds):
		var c = Sprite2D.new()
		c.visible = false
		pool.push_back(c)

	for x in range(0, max_clouds):
		add_child(reset_clouds())
		for c in fast_clouds:
			c.position.x = randi_range(-_max_x, _max_x)
		for c in slow_clouds:
			c.position.x = randi_range(-_max_x, _max_x)

func reset_clouds():
	if pool.size() == 0:
		return

	if (fast_clouds.size() + slow_clouds.size()) >= max_clouds:
		return

	var c = pool[0]
	pool.remove_at(0)
	
	var is_fast = randi_range(0, 100) % 2 == 0
	if is_fast:
		fast_clouds.push_back(c)
	else:
		slow_clouds.push_back(c)
	
	var cloud_tex = tex[randi_range(0, tex.size() - 1)]
	c.position = Vector2(-cloud_tex.get_width() - randi_range(0, 200), _get_y())
	c.texture = cloud_tex
	c.visible = true
	return c

func reap_clouds():
	var fast_to_remove = fast_clouds.filter(func(c): return !_on_screen(c.position))
	var slow_to_remove = slow_clouds.filter(func(c): return !_on_screen(c.position))

	fast_clouds = fast_clouds.filter(func(c): return _on_screen(c.position))
	slow_clouds = slow_clouds.filter(func(c): return _on_screen(c.position))

	for x in fast_to_remove:
		pool.push_back(x)
	for x in slow_to_remove:
		pool.push_back(x)

func _process(delta):
	reset_clouds()

	for c in fast_clouds:
		c.position.x += (delta * fast_clouds_vel)
	for c in slow_clouds:
		c.position.x += (delta * slow_clouds_vel)

	reap_clouds()
