extends CharacterBody2D

@export var speed: int = 100

var directions: PackedStringArray = PackedStringArray(["east", "south_east", "south", "south_west", "west", "north_west", "north", "north_east"])
var last_direction: String = "south"

func _physics_process(_delta) -> void:
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var angle: float = input_direction.angle()
	var step: int = snapped(angle, PI/4) / (PI/4)
	var index: int = wrapi(int(step), 0, 8)
	
	if input_direction.length() != 0:
		$AnimatedSprite2D.animation = directions[index]
		last_direction = directions[index]
	else:
		$AnimatedSprite2D.animation = "idle_" + last_direction
	
	$AnimatedSprite2D.play()
	velocity = input_direction * speed
	
	move_and_slide()
