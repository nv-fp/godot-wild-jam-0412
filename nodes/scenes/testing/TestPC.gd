extends Node2D

@export var speed = 400
@export var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func up() -> bool:
	return Input.is_action_pressed('ui_up')

func down() -> bool:
	return Input.is_action_pressed('ui_down')

func right() -> bool:
	return Input.is_action_pressed('ui_right')

func left() -> bool:
	return Input.is_action_pressed('ui_left')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = 0
	var y = 0
	
	if up():
		y -= 1
	if down():
		y += 1
	if right():
		x += 1
	if left():
		x -= 1
	
	var pos_update = Vector2(x, y).normalized() * speed * delta
	position += pos_update
