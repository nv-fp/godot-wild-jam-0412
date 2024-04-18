extends CharacterBody2D

# We can also export this and set in the designer
# but the character will be a parent of the tilemap for y-sorting to work properly
@onready var tilemap: TileMap = get_parent()
@export var speed: int = 100

var scenes = {
	"Bronze_Ore": preload("res://nodes/items/Bronze_Ore.tscn"),
	"Gold_Ore": preload("res://nodes/items/Gold_Ore.tscn"),
	"Diamond_Ore": preload("res://nodes/items/Diamond_Ore.tscn"),
	"Leather_Hide": preload("res://nodes/items/Leather.tscn"),
	"Wood": preload("res://nodes/items/Wood.tscn"),
	"Bronze_Shield_Chunk": preload("res://nodes/items/Bronze_Shield_Chunk.tscn"),
	"Gold_Shield_Chunk": preload("res://nodes/items/Gold_Shield_Chunk.tscn"),
	"Diamond_Shield_Chunk": preload("res://nodes/items/Diamond_Shield_Chunk.tscn"),
	"Bronze_Shield": preload("res://nodes/items/Bronze_Shield.tscn"),
	"Gold_Shield": preload("res://nodes/items/Gold_Shield.tscn"),
	"Diamond_Shield": preload("res://nodes/items/Diamond_Shield.tscn"),
	"Bronze_Blade_Chunk": preload("res://nodes/items/Bronze_Blade_Chunk.tscn"),
	"Gold_Blade_Chunk": preload("res://nodes/items/Gold_Blade_Chunk.tscn"),
	"Diamond_Blade_Chunk": preload("res://nodes/items/Diamond_Blade_Chunk.tscn"),
	"Bronze_Blade": preload("res://nodes/items/Bronze_Blade.tscn"),
	"Gold_Blade": preload("res://nodes/items/Gold_Blade.tscn"),
	"Diamond_Blade": preload("res://nodes/items/Diamond_Blade.tscn"),
	"Bronze_Sword": preload("res://nodes/items/Bronze_Sword.tscn"),
	"Gold_Sword": preload("res://nodes/items/Gold_Sword.tscn"),
	"Diamond_Sword": preload("res://nodes/items/Diamond_Sword.tscn"),
	"Bronze_Gem_Chunk": preload("res://nodes/items/Bronze_Gem_Chunk.tscn"),
	"Gold_Gem_Chunk": preload("res://nodes/items/Gold_Gem_Chunk.tscn"),
	"Diamond_Gem_Chunk": preload("res://nodes/items/Diamond_Gem_Chunk.tscn"),
	"Bronze_Gem": preload("res://nodes/items/Bronze_Gem.tscn"),
	"Gold_Gem": preload("res://nodes/items/Gold_Gem.tscn"),
	"Diamond_Gem": preload("res://nodes/items/Diamond_Gem.tscn"),
	"Bronze_Staff": preload("res://nodes/items/Bronze_Staff.tscn"),
	"Gold_Staff": preload("res://nodes/items/Gold_Staff.tscn"),
	"Diamond_Staff": preload("res://nodes/items/Diamond_Staff.tscn"),
	"Polished_Bronze_Shield": preload("res://nodes/items/Polished_Bronze_Shield.tscn"),
	"Polished_Gold_Shield": preload("res://nodes/items/Polished_Gold_Shield.tscn"),
	"Polished_Diamond_Shield": preload("res://nodes/items/Polished_Diamond_Shield.tscn"),
	"Polished_Bronze_Sword": preload("res://nodes/items/Polished_Bronze_Sword.tscn"),
	"Polished_Gold_Sword": preload("res://nodes/items/Polished_Gold_Sword.tscn"),
	"Polished_Diamond_Sword": preload("res://nodes/items/Polished_Diamond_Sword.tscn")
}

var atlas_coords = {
	"Bronze_Ore": Vector2(2, 0),
	"Gold_Ore": Vector2(3, 0),
	"Diamond_Ore": Vector2(4, 0),
	"Leather_Hide": Vector2(0, 0),
	"Wood": Vector2(1, 0),
	"Anvil": Vector2(0, 0),
	"Furnace": Vector2(0, 1),
	"Trash": Vector2(0, 0),
	"Craft": Vector2(0, 0),
	"Tub": Vector2(0, 0),
}

var atlas_ids = {
	"Bronze_Ore": 14,
	"Gold_Ore": 14,
	"Diamond_Ore": 14,
	"Leather_Hide": 14,
	"Wood": 14,
	"Anvil": 19,
	"Furnace": 18,
	"Trash": 9,
	"Craft": 24,
	"Tub": 23
}

var atlas_layers = {
	"Bronze_Ore": 2,
	"Gold_Ore": 2,
	"Diamond_Ore": 2,
	"Leather_Hide": 2,
	"Wood": 2,
	"Anvil": 1,
	"Furnace": 1,
	"Trash": 1,
	"Craft": 1,
	"Tub": 1
}

var item_scales = {
	"Bronze_Ore": Vector2(0.6, 0.6),
	"Gold_Ore": Vector2(0.6, 0.6),
	"Diamond_Ore": Vector2(0.6, 0.6),
	"Leather_Hide": Vector2(0.6, 0.6),
	"Wood": Vector2(0.6, 0.6),
	"Bronze_Shield_Chunk": Vector2(1, 1),
	"Gold_Shield_Chunk": Vector2(1, 1),
	"Diamond_Shield_Chunk": Vector2(1, 1),
	"Bronze_Shield": Vector2(1,1),
	"Gold_Shield": Vector2(1, 1),
	"Diamond_Shield": Vector2(1, 1),
	"Bronze_Blade_Chunk": Vector2(1, 1),
	"Gold_Blade_Chunk": Vector2(1, 1),
	"Diamond_Blade_Chunk": Vector2(1, 1),
	"Bronze_Blade": Vector2(1, 1),
	"Gold_Blade": Vector2(1, 1),
	"Diamond_Blade": Vector2(1, 1),
	"Bronze_Sword": Vector2(1, 1),
	"Gold_Sword": Vector2(1, 1),
	"Diamond_Sword": Vector2(1, 1),
	"Bronze_Gem_Chunk": Vector2(1, 1),
	"Gold_Gem_Chunk": Vector2(1, 1),
	"Diamond_Gem_Chunk": Vector2(1, 1),
	"Bronze_Gem": Vector2(1, 1),
	"Gold_Gem": Vector2(1, 1),
	"Diamond_Gem": Vector2(1, 1),
	"Bronze_Staff": Vector2(1, 1),
	"Gold_Staff": Vector2(1, 1),
	"Diamond_Staff": Vector2(1, 1),
	"Polished_Bronze_Shield": Vector2(1, 1),
	"Polished_Gold_Shield": Vector2(1, 1),
	"Polished_Diamond_Shield": Vector2(1, 1),
	"Polished_Bronze_Sword": Vector2(1, 1),
	"Polished_Gold_Sword": Vector2(1, 1),
	"Polished_Diamond_Sword": Vector2(1, 1)
}

var furnace_allowed_items = ["Bronze_Ore", "Gold_Ore", "Diamond_Ore"]
var anvil_allowed_items = ["Bronze_Shield_Chunk", "Gold_Shield_Chunk", "Diamond_Shield_Chunk", "Bronze_Blade_Chunk", "Gold_Blade_Chunk", "Diamond_Blade_Chunk", "Bronze_Gem_Chunk", "Gold_Gem_Chunk", "Diamond_Gem_Chunk"]
var table_allowed_items = ["Bronze_Blade", "Gold_Blade", "Diamond_Blade", "Leather_Hide", "Bronze_Gem", "Gold_Gem", "Diamond_Gem", "Wood"]
var tub_allowed_items = ["Bronze_Shield", "Gold_Shield", "Diamond_Shield", "Bronze_Sword", "Gold_Sword", "Diamond_Sword"]

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
			"Diamond_Ore","Gold_Ore","Bronze_Ore","Leather_Hide", "Wood":
				if heldItem == null:
					spawn_in_held_item(group)
			"Anvil":
				var anvil = tilemap.anvils.filter(func (a): return a.area == interactable).front()

				if  heldItem == null && anvil.inventory.size() == 1 && anvil.smithing:
					anvil.smithing = false
					clear_interactable(anvil)
					return

				if heldItem && !anvil.smithing:
					var item = heldItem.get_groups()[0]
					
					if !anvil_allowed_items.has(item):
						return

					anvil.inventory.append(str(item))
					remove_held_item()
					anvil.recipe = "_".join(item.split("_").slice(0, 2))
					
					if anvil.recipes.has(anvil.recipe):
						smithingItem = true
						anvil.smithing = true
						anvil.timer = create_timer()
						anvil.timer.run_time = 5
						add_child(anvil.timer)
						anvil.timer.position = get_location_from_group(group, anvil.tile) - anvil.timer_position
						anvil.timer.start()
						await anvil.timer.timeout
						smithingItem = false
						anvil.inventory = [anvil.recipe]
						anvil.timer.queue_free()
						anvil.timer = null
						spawn_finished_item(anvil.recipe, anvil)
			"Furnace":
				var furnace = tilemap.furnaces.filter(func (f): return f.area == interactable).front()
				# Our item finished smelting and we need to collect it
				if heldItem == null && furnace.inventory.size() == 1 && furnace.smelting:
					furnace.smelting = false
					clear_interactable(furnace)
					return
				
				if furnace.inventory.size() > 2:
					return

				# If we are holding an item
				if heldItem != null && !furnace.smelting:
					var resource = heldItem.get_groups()[0]
					
					if !furnace_allowed_items.has(resource):
						return
					
					if !furnace.inventory.all(func(r): return r == resource):
						print("Not Everything inside was same, disgard interact action")
						return

					furnace.inventory.append(str(resource))
					furnace.toast.add_material(str(resource))

					remove_held_item()
					match furnace.inventory.size():
						1:
							furnace.recipe = resource.split("_")[0] + "_Gem_Chunk"
						2:
							furnace.recipe = resource.split("_")[0] + "_Blade_Chunk"
						3:
							furnace.recipe = resource.split("_")[0] + "_Shield_Chunk"
			"Craft":
				var table = tilemap.tables.filter(func (t): return t.area == interactable).front()
				if heldItem == null && table.inventory.size() == 1 && table.crafting:
					table.crafting = false
					clear_interactable(table)
					return
				
				if table.inventory.size() > 1:
					return
					
				if heldItem != null && !table.crafting:
					var resource = heldItem.get_groups()[0]
					
					if !table_allowed_items.has(resource):
						return
					
					if table.inventory.any(func(r): return r == resource):
						print("You already put one of those in there!")
						return
					
					remove_held_item()
					
					if resource == "Leather_Hide":
						if table.recipe:
							table.recipe = table.recipe + "_Sword"
						else:
							table.recipe = "_Sword"
						table.inventory.append(str(resource))
					elif resource == "Wood":
						if table.recipe:
							table.recipe = table.recipe + "_Staff"
						else:
							table.recipe = "_Staff"
						table.inventory.append(str(resource))
					else:
						var mat = resource.split("_")[0]
						if table.recipe:
							table.recipe = mat + table.recipe
						else:
							table.recipe = mat
						table.inventory.push_front(str(resource))
					
					table.toast.add_material(str(resource))
						

					if table.recipes.has(table.recipe) && table.inventory == table.recipes.get(table.recipe):
						table.toast.clear()
						table.crafting = true
						table.timer = create_timer()
						table.timer.run_time = 5
						add_child(table.timer)
						table.timer.position = get_location_from_group(group, table.tile) - table.timer_position
						table.timer.start()
						await table.timer.timeout
						table.inventory = [table.recipe]
						table.timer.queue_free()
						table.timer = null
						spawn_finished_item(table.recipe, table)
			"Tub":
				var tub = tilemap.tubs.filter(func (t): return t.area == interactable).front()
				
				if heldItem == null && tub.inventory.size() == 1 && tub.polishing && tub.timer == null:
					tub.polishing = false
					clear_interactable(tub)
					return
				
				if tub.inventory.size() > 0:
					return
					
				if heldItem != null && !tub.polishing:
					var resource = heldItem.get_groups()[0]
					
					if !tub_allowed_items.has(resource):
						return

					remove_held_item()
					tub.inventory.append(str(resource))
					tub.recipe = "Polished_" + resource

					if tub.recipes.has(tub.recipe) && tub.inventory == tub.recipes.get(tub.recipe) && !tub.polishing:
						tub.polishing = true
						tub.timer = create_timer()
						tub.timer.run_time = 5
						add_child(tub.timer)
						tub.timer.position = get_location_from_group(group, tub.tile) - tub.timer_position
						tub.timer.start()
						await tub.timer.timeout
						spawn_finished_item(tub.recipe, tub)
						tub.inventory = [tub.recipe]
						tub.timer.queue_free()
						tub.timer = null
			"Trash":
				if heldItem != null:
					remove_held_item()

func handle_start_interaction_input():
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"Furnace":
				var furnace = tilemap.furnaces.filter(func (f): return f.area == interactable).front()
				if furnace.recipes.has(furnace.recipe) && !furnace.smelting:
					print("Starting smelting for " + furnace.recipe)
					furnace.toast.clear()
					furnace.smelting = true
					furnace.timer = create_timer()
					furnace.timer.connect("timeout", furnace_timer_timeout.bind(furnace))
					furnace.timer.run_time = 5
					add_child(furnace.timer)
					furnace.timer.start()
					furnace.timer.position = get_location_from_group(group, furnace.tile) - furnace.timer_position


func get_location_from_group(group: String, tile: Vector2) -> Vector2:
	if !tile:
		tile = tilemap.get_used_cells_by_id(atlas_layers.get(group), atlas_ids.get(group), atlas_coords.get(group))[0]
	if tile:
		if group == "Anvil":
			return tilemap.map_to_local(tile)
		else:
			return tilemap.map_to_local(tile) - Vector2(0, -10)
	else:
		return Vector2(0, 0)

func furnace_timer_timeout(_id: String, furnace):
	var itemToSpawn = furnace.recipe
	furnace.inventory = [furnace.recipe]
	remove_child(furnace.timer)
	spawn_finished_item(itemToSpawn, furnace)
	furnace.timer = null
	

func clear_interactable(interactable):
	print("Picking up item from interactable")
	var item = interactable.inventory[0]
	interactable.recipe = null
	interactable.inventory = []
	spawn_in_held_item(item)
	remove_child(interactable.finished_item)
	interactable.finished_item = null

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
	node.scale = item_scales.get(item)
	node.y_sort_enabled = false
	node.z_index = 2
	node.position = $Marker2D.position

func spawn_finished_item(item: String, interactable):
	var sceneToCreate = scenes.get(item)
	var node = sceneToCreate.instantiate()
	add_child(node)
	node.scale = item_scales.get(item)
	node.z_index = 6
	node.y_sort_enabled = false
	node.position = interactable.toast.position
	node.top_level = true
	interactable.finished_item = node

func remove_held_item() -> Node2D:
		var node = heldItem
		heldItem = null
		pickedUpItem = false
		remove_child(node)
		return node
		

func create_timer() -> Node2D:
	var timer = smithingTimerScene.instantiate()
	timer.autostart = false
	timer.z_index = 6
	timer.top_level = true
	timer.rotation_degrees = 90
	timer.scale = Vector2(0.4, 0.4)
	timer.fg_color_lots = Color.DARK_GREEN
	timer.fg_color_med = Color.DARK_GREEN
	timer.fg_color_low = Color.DARK_GREEN
	timer.radius = 5
	timer.bar_height = 10 * 6
	return timer

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
	



