extends Area2D

@export var resource: StringName = &"bronze_ore"
@export var flip_horizontally: bool = false

@onready var collision: CollisionPolygon2D = get_node("CollisionShape")
# In the future these two will be merged into a single animatedsprite2d
@onready var sprite: Sprite2D = get_node("Sprite")


func interact(player: Blacksmith, action: StringName) -> bool:
	match action:
		&"interaction":
			if player.heldItem == null:
				player.equip_item(resource)
				return true
	return false

func _ready():
	if flip_horizontally:
		flip_crate()

func flip_crate():
	var collision = get_node("CollisionShape")
	collision.scale.x = collision.scale.x * -1
	sprite.flip_h = true
