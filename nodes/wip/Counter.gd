extends Node2D
class_name Counter

enum CounterStates {
	EMPTY,
	FULL
}

# The Tile this crate represents
var flip_horizontally: bool = false
var tile: Vector2i

var stored_item: Node2D
var state: CounterStates = CounterStates.EMPTY

@onready var sprite: Sprite2D = get_node("Sprite")
@onready var item_marker: Marker2D = get_node("ItemPosition")

func flip():
	var collision = get_node("CollisionShape")
	collision.scale.x = collision.scale.x * -1
	sprite.flip_h = true

func interact(player: Blacksmith, action: StringName) -> bool: 
	match action:
		&"interaction":
			match state:
				CounterStates.EMPTY:
					if player.heldItem != null:
						var item = player.unequip_item()
						add_item(item)
						return true
				CounterStates.FULL:
					if player.heldItem == null:
						var item = remove_item()
						player.equip_item(item.get_groups()[0])
						item.queue_free()
						return true
	return false


func add_item(item: Node2D) -> void:
	add_child(item)
	item.position = item_marker.position
	stored_item = item
	state = CounterStates.FULL

func remove_item() -> Node2D:
	remove_child(stored_item)
	var item = stored_item
	stored_item = null
	state = CounterStates.EMPTY
	return item
	
