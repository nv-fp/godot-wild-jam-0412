extends CharacterBody2D

# We can also export this and set in the designer
# but the character will be a parent of the tilemap for y-sorting to work properly
@onready var tilemap: TileMap = get_parent()
@export var speed: int = 100

var scenes = {
	"Bronze": preload("res://nodes/items/Bronze.tscn"),
	"Gold": preload("res://nodes/items/Gold.tscn"),
	"Diamond": preload("res://nodes/items/Diamond.tscn"),
	"Unfinished_Bronze_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn")
	#"Unfinished_Gold_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn"),
	#"Unfinished_Diamond_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn")
}

var atlas_coords = {
	"Bronze": Vector2(2, 0),
	"Gold": Vector2(3, 0),
	"Diamond": Vector2(4, 0),
	"Anvil": Vector2(0, 0),
	"Furnace": Vector2(0, 1)
}

var atlas_ids = {
	"Bronze": 14,
	"Gold": 14,
	"Diamond": 14,
	"Anvil": 19,
	"Furnace": 18
}

var atlas_layers = {
	"Bronze": 2,
	"Gold": 2,
	"Diamond": 2,
	"Anvil": 1,
	"Furnace": 1
}


var pickedUpItem = false
var heldItem: Node2D
var interactable: Area2D

var smithingItem = false

var directions: PackedStringArray = PackedStringArray(["east", "south_east", "south", "south_west", "west", "north_west", "north", "north_east"])
var last_direction: String = "south"
var last_direction_vector: Vector2 = Vector2(0, 1)

func basic_movement():
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var angle: float = input_direction.angle()
	var step: int = snapped(angle, PI/4) / (PI/4)
	var index: int = wrapi(int(step), 0, 8)	
	if input_direction.length() != 0:
		$AnimatedSprite2D.animation = directions[index]
		last_direction = directions[index]
		last_direction_vector = input_direction
	else:
		$AnimatedSprite2D.animation = "idle_" + last_direction
		
	$AnimatedSprite2D.play()	
	velocity = input_direction * speed
	move_and_slide()
	
	
func show_interact_button():
	if interactable && !smithingItem:
		var group = interactable.get_groups()[0]
		var tile = tilemap.get_used_cells_by_id(atlas_layers.get(group), atlas_ids.get(group), atlas_coords.get(group))[0]
		if tile:
			$InteractPrompt.visible = true
			$InteractPrompt.position = tilemap.map_to_local(tile) - Vector2(0, -10)
		else:
			$InteractPrompt.visible = false
	else:
		$InteractPrompt.visible = false

func handleInteractionInput() -> void:
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"Diamond","Gold","Bronze":
				spawn_in_held_item(group)
			"Anvil":
				if heldItem == null:
					return
				smithingItem = true
				remove_held_item()
				print("Starting to smith Item!")
				await get_tree().create_timer(5.0).timeout
				print("Done smithing item!")
				spawn_in_held_item("Unfinished_Bronze_Sword")
				smithingItem = false

func spawn_in_held_item(item):
	if heldItem != null:
		return
	pickedUpItem = true
	var sceneToCreate = scenes.get(item)
	var node = sceneToCreate.instantiate()
	heldItem = node
	add_child(node)
	node.scale.x = 0.25
	node.scale.y = 0.25
	node.y_sort_enabled = false
	node.z_index = 2
	node.position = $Marker2D.position

func remove_held_item() -> Node2D:
		var node = heldItem
		heldItem = null
		pickedUpItem = false
		remove_child(node)
		return node

func _physics_process(_delta) -> void:
	if !smithingItem:
		basic_movement()
	show_interact_button()
	
func _process(_delta) -> void:
	if smithingItem:
		return
	if Input.is_action_just_pressed("interaction"):
		handleInteractionInput()
	if Input.is_action_just_pressed("drop_item"):
		var item = remove_held_item()
		tilemap.add_child(item)
		item.z_index = 1
		item.y_sort_enabled = true
		item.scale.x = .5
		item.scale.y = .5
		item.position = position
	


