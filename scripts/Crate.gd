extends Node2D

@export var flip_collision: bool = false
@export var frame: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = frame
	
	if flip_collision:
		$Area2D.scale.x = -1
	else:
		$Area2D.scale.x = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
