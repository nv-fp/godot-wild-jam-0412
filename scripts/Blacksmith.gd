extends CharacterBody2D

# We can also export this and set in the designer
# but the character will be a parent of the tilemap for y-sorting to work properly
@onready var tilemap: TileMap = get_parent()
@export var speed: int = 100

var scenes = {
	"Bronze_Ore": preload("res://nodes/items/Bronze_Ore.tscn"),
	"Gold_Ore": preload("res://nodes/items/Gold_Ore.tscn"),
	"Diamond_Ore": preload("res://nodes/items/Diamond_Ore.tscn"),
	"Unfinished_Bronze_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn"),
	#"Unfinished_Gold_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn"),
	#"Unfinished_Diamond_Sword": preload("res://nodes/items/Unfinished_Bronze_Sword.tscn"),
	"Bronze_Shield_Chunk": preload("res://nodes/items/Bronze_Shield_Chunk.tscn"),
	"Gold_Shield_Chunk": preload("res://nodes/items/Gold_Shield_Chunk.tscn"),
	"Diamond_Shield_Chunk": preload("res://nodes/items/Diamond_Shield_Chunk.tscn"),
	"Bronze_Shield": preload("res://nodes/items/Bronze_Shield.tscn"),
	"Gold_Shield": preload("res://nodes/items/Gold_Shield.tscn"),
	"Diamond_Shield": preload("res://nodes/items/Diamond_Shield.tscn"),
}

var atlas_coords = {
	"Bronze_Ore": Vector2(2, 0),
	"Gold_Ore": Vector2(3, 0),
	"Diamond_Ore": Vector2(4, 0),
	"Anvil": Vector2(0, 0),
	"Furnace": Vector2(0, 1)
}

var atlas_ids = {
	"Bronze_Ore": 14,
	"Gold_Ore": 14,
	"Diamond_Ore": 14,
	"Anvil": 19,
	"Furnace": 18
}

var atlas_layers = {
	"Bronze_Ore": 2,
	"Gold_Ore": 2,
	"Diamond_Ore": 2,
	"Anvil": 1,
	"Furnace": 1
}

var recipes = {
	"Bronze_Shield_Chunk": ["Bronze_Ore", "Bronze_Ore", "Bronze_Ore"],
	"Gold_Shield_Chunk": ["Gold_Ore", "Gold_Ore", "Gold_Ore"],
	"Diamond_Shield_Chunk": ["Diamond_Ore", "Diamond_Ore", "Diamond_Ore"],
	"Bronze_Shield": ["Bronze_Shield_Chunk"],
	"Gold_Shield": ["Gold_Shield_Chunk"],
	"Diamond_Shield": ["Diamond_Shield_Chunk"]
}

var pickedUpItem = false
var heldItem: Node2D
var interactable: Area2D

var smithingItem: bool = false
var smithingTimerScene: PackedScene = preload("res://nodes/scenes/cowndown_timer.tscn")
var smithingTimer: Node2D

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

func handle_interaction_input() -> void:
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"Diamond_Ore","Gold_Ore","Bronze_Ore":
				spawn_in_held_item(group)
			"Anvil":
				
				### Come back here and do something similar like I did with Furnace
				if heldItem == null:
					return
				smithingItem = true
				remove_held_item()
				smithingTimer = smithingTimerScene.instantiate()
				smithingTimer.autostart = false
				smithingTimer.connect("timeout", smithing_timer_timeout)
				smithingTimer.run_time = 5
				add_child(smithingTimer)
				smithingTimer.start()
				smithingTimer.position = get_location_from_group(interactable.get_groups()[0]) - Vector2(0, 30)
				smithingTimer.z_index = 4
				smithingTimer.top_level = true
				smithingTimer.scale.x = 0.4
				smithingTimer.scale.y = 0.4
			"Furnace":
				var furnace = tilemap.furnaces[0]
				# Our item finished smelting and we need to collect it
				if heldItem == null && furnace.inventory[0] == furnace.recipe:
					clear_furnace(furnace)
					return
				
				if furnace.inventory.size() > 2:
					return

				# If we are holding an item
				if heldItem != null && !furnace.smelting:
					var resource = heldItem.get_groups()[0]
					
					if !furnace.inventory.all(func(r): return r == resource):
						print("Not Everything inside was same, disgard interact action")
						return
					furnace.inventory.append(resource)
					
					remove_held_item()
					match furnace.inventory.size():
						0:
							furnace.recipe = resource.split(" ")[0] + "_Staff_Chunk"
						1:
							furnace.recipe = resource.split(" ")[0] + "_Sword_Chunk"
						2:
							furnace.recipe = resource.split(" ")[0] + "_Shield_Chunk"
					
func handle_start_interaction_input():
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"Furnace":
				var furnace = tilemap.furnaces[0]
				if recipes.has(furnace.recipe) && !furnace.smelting:
					print("Starting smelting for " + furnace.recipe)
					furnace.smelting = true
					furnace.timer = smithingTimerScene.instantiate()
					furnace.timer.autostart = false
					furnace.timer.connect("timeout", furnace_timer_timeout.bind(furnace))
					furnace.timer.run_time = 5
					add_child(furnace.timer)
					furnace.timer.start()
					furnace.timer.position = get_location_from_group(group) - Vector2(0, 30)
					furnace.timer.z_index = 4
					furnace.timer.top_level = true
					furnace.timer.scale.x = 0.4
					furnace.timer.scale.y = 0.4
					

func get_location_from_group(group: String) -> Vector2:
	var tile = tilemap.get_used_cells_by_id(atlas_layers.get(group), atlas_ids.get(group), atlas_coords.get(group))[0]
	if tile:
		if group == "Anvil":
			return tilemap.map_to_local(tile)
		else:
			return tilemap.map_to_local(tile) - Vector2(0, -10)
	else:
		return Vector2(0, 0)

func smithing_timer_timeout(_id: String):
	smithingItem = false
	remove_child(smithingTimer)
	smithingTimer = null
	spawn_in_held_item("Unfinished_Bronze_Sword")

func furnace_timer_timeout(_id: String, furnace):
	furnace.smelting = false
	var itemToSpawn = furnace.recipe
	furnace.inventory = [furnace.recipe]
	furnace.timer = null

func clear_furnace(furnace):
	print("Picking Up Item From Furnace")
	var item = furnace.inventory[0]
	furnace.recipe = null
	furnace.inventory = []
	spawn_in_held_item(item)

func spawn_in_held_item(item: String):
	print("Spawning in Item " + item)
	if heldItem != null:
		return
	pickedUpItem = true
	var sceneToCreate = scenes.get(item)
	var node = sceneToCreate.instantiate()
	heldItem = node
	node.add_to_group(item)
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
		handle_interaction_input()
	if Input.is_action_just_pressed("start_block"):
		handle_start_interaction_input()
	if Input.is_action_just_pressed("drop_item"):
		var item = remove_held_item()
		tilemap.add_child(item)
		item.z_index = 1
		item.y_sort_enabled = true
		item.scale.x = .5
		item.scale.y = .5
		item.position = position
	



