extends CharacterBody2D

# We can also export this and set in the designer
# but the character will be a parent of the tilemap for y-sorting to work properly
@onready var tilemap: TileMap = get_parent()
@export var speed: int = 175

var immobile = true

var polishing_time = 3
var anvil_time = 3
var furnace_time = 3
var craft_time = 3


var atlas_coords = {
	"bronze_ore": Vector2(2, 0),
	"gold_ore": Vector2(3, 0),
	"diamond_ore": Vector2(4, 0),
	"leather_hide": Vector2(0, 0),
	"wood": Vector2(1, 0),
	"anvil": Vector2(0, 0),
	"furnace": Vector2(0, 1),
	"trash": Vector2(0, 0),
	"craft": Vector2(0, 0),
	"tub": Vector2(0, 0),
}

var atlas_ids = {
	"bronze_ore": 14,
	"gold_ore": 14,
	"diamond_ore": 14,
	"leather_hide": 14,
	"wood": 14,
	"anvil": 19,
	"furnace": 18,
	"trash": 9,
	"craft": 24,
	"tub": 23
}

var atlas_layers = {
	"bronze_ore": 2,
	"gold_ore": 2,
	"diamond_ore": 2,
	"leather_hide": 2,
	"wood": 2,
	"anvil": 1,
	"furnace": 1,
	"trash": 1,
	"craft": 1,
	"tub": 1
}

var item_scales = {
	"bronze_ore": Vector2(0.6, 0.6),
	"gold_ore": Vector2(0.6, 0.6),
	"diamond_ore": Vector2(0.6, 0.6),
	"leather_hide": Vector2(0.6, 0.6),
	"wood": Vector2(0.6, 0.6),
	"bronze_shield_chunk": Vector2(1, 1),
	"gold_shield_chunk": Vector2(1, 1),
	"diamond_shield_chunk": Vector2(1, 1),
	"bronze_shield": Vector2(1,1),
	"gold_shield": Vector2(1, 1),
	"diamond_shield": Vector2(1, 1),
	"bronze_blade_chunk": Vector2(1, 1),
	"gold_blade_chunk": Vector2(1, 1),
	"diamond_blade_chunk": Vector2(1, 1),
	"bronze_blade": Vector2(1, 1),
	"gold_blade": Vector2(1, 1),
	"diamond_blade": Vector2(1, 1),
	"bronze_sword": Vector2(1, 1),
	"gold_sword": Vector2(1, 1),
	"diamond_sword": Vector2(1, 1),
	"bronze_gem_chunk": Vector2(1, 1),
	"gold_gem_chunk": Vector2(1, 1),
	"diamond_gem_chunk": Vector2(1, 1),
	"bronze_gem": Vector2(1, 1),
	"gold_gem": Vector2(1, 1),
	"diamond_gem": Vector2(1, 1),
	"bronze_staff": Vector2(1, 1),
	"gold_staff": Vector2(1, 1),
	"diamond_staff": Vector2(1, 1),
	"polished_bronze_shield": Vector2(1, 1),
	"polished_gold_shield": Vector2(1, 1),
	"polished_diamond_shield": Vector2(1, 1),
	"polished_bronze_sword": Vector2(1, 1),
	"polished_gold_sword": Vector2(1, 1),
	"polished_diamond_sword": Vector2(1, 1),
	"polished_bronze_staff": Vector2(1, 1),
	"polished_gold_staff": Vector2(1, 1),
	"polished_diamond_staff": Vector2(1, 1)
}

var furnace_allowed_items = ["bronze_ore", "gold_ore", "diamond_ore"]
var anvil_allowed_items = ["bronze_shield_chunk", "gold_shield_chunk", "diamond_shield_chunk", "bronze_blade_chunk", "gold_blade_chunk", "diamond_blade_chunk", "bronze_gem_chunk", "gold_gem_chunk", "diamond_gem_chunk"]
var table_allowed_items = ["bronze_blade", "gold_blade", "diamond_blade", "leather_hide", "bronze_gem", "gold_gem", "diamond_gem", "wood"]
var tub_allowed_items = ["bronze_shield", "gold_shield", "diamond_shield", "bronze_sword", "gold_sword", "diamond_sword", "bronze_staff", "gold_staff", "diamond_staff"]

var pickedUpItem = false
var heldItem: Node2D
var interactable: Area2D

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
	if input_direction.length() != 0 && !immobile:
		if $Footsteps.playing == false:
			$Footsteps.playing = true
		$AnimatedSprite2D.animation = directions[index]
		last_direction = directions[index]
		last_direction_vector = input_direction
	else:
		$Footsteps.playing = false
		$AnimatedSprite2D.animation = "idle_" + last_direction
		
	$AnimatedSprite2D.play()
	velocity = input_direction * speed
	move_and_slide()
	
	
func show_interact_button():
	if interactable:
		$InteractPrompt.visible = true
		if !heldItem:
			$InteractPrompt.position = position + Vector2(0, 20)
		else:
			$InteractPrompt.position = position + Vector2(0, 5)
	else:
		$InteractPrompt.visible = false

func handle_interaction_input() -> void:
	if interactable:
		var group = interactable.get_groups()[0]
		print(group)
		match group:
			"diamond_ore","gold_ore","bronze_ore","leather_hide", "wood":
				if heldItem == null:
					spawn_in_held_item(group)
					$GrabItem.playing = true
			"anvil":
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
						immobile = true
						anvil.smithing = true
						anvil.timer = create_timer()
						anvil.timer.run_time = anvil_time
						add_child(anvil.timer)
						anvil.timer.position = get_location_from_group(group, anvil.tile) - anvil.timer_position
						anvil.timer.start()
						$Anviling.playing = true
						await anvil.timer.timeout
						$Anviling.playing = false
						immobile = false
						anvil.inventory = [anvil.recipe]
						anvil.timer.queue_free()
						anvil.timer = null
						spawn_finished_item(anvil.recipe, anvil)
			"furnace":
				var furnace = tilemap.furnaces.filter(func (f): return f.area == interactable).front()
				# Our item finished smelting and we need to collect it
				if heldItem == null && furnace.inventory.size() == 1 && furnace.smelting && furnace.inventory[0] == furnace.recipe:
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
							furnace.recipe = resource.split("_")[0] + "_gem_chunk"
						2:
							furnace.recipe = resource.split("_")[0] + "_blade_chunk"
						3:
							furnace.recipe = resource.split("_")[0] + "_shield_chunk"
			"craft":
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
					
					# dirty hack to prevent putting in leather with staff or wood with sword
					# too lazy to do this any other way
					if table.inventory.size() > 0:
						print(table.inventory[0])
						print(resource)
						match resource:
							"leather_hide":
								if !table.inventory[0].ends_with("blade"):
									return
							"wood":
								if !table.inventory[0].ends_with("gem"):
									return
							"bronze_gem","gold_gem","diamond_gem":
								if table.inventory[0] == "leather_hide":
									return
							"bronze_blade","gold_blade","diamond_blade":
								if table.inventory[0] == "wood":
									return
					
					
					remove_held_item()
					
					if resource == "leather_hide":
						if table.recipe:
							table.recipe = table.recipe + "_sword"
						else:
							table.recipe = "_sword"
						table.inventory.append(str(resource))
					elif resource == "wood":
						if table.recipe:
							table.recipe = table.recipe + "_staff"
						else:
							table.recipe = "_staff"
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
						table.timer.run_time = craft_time
						add_child(table.timer)
						table.timer.position = get_location_from_group(group, table.tile) - table.timer_position
						table.timer.start()
						$Crafting.playing = true
						await table.timer.timeout
						$Crafting.playing = false
						table.inventory = [table.recipe]
						table.timer.queue_free()
						table.timer = null
						spawn_finished_item(table.recipe, table)
			"tub":
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
					tub.recipe = "polished_" + resource

					if tub.recipes.has(tub.recipe) && tub.inventory == tub.recipes.get(tub.recipe) && !tub.polishing:
						tub.polishing = true
						tub.timer = create_timer()
						tub.timer.run_time = polishing_time
						add_child(tub.timer)
						tub.timer.position = get_location_from_group(group, tub.tile) - tub.timer_position
						tub.timer.start()
						$Polishing.playing = true
						await tub.timer.timeout
						$Polishing.playing = false
						spawn_finished_item(tub.recipe, tub)
						tub.inventory = [tub.recipe]
						tub.timer.queue_free()
						tub.timer = null
			"trash":
				if heldItem != null:
					$TrashCan.playing = true
					remove_held_item()
			"delivery":
				if heldItem != null:
					var queue = get_tree().current_scene.active_level.get_node("Hud").get_node("OrderQueue")
					var item = heldItem.get_groups()[0]
					if item.begins_with("polished") && queue.fill("_".join(item.split("_").slice(1))):
						remove_held_item()
						# PLAY DING SOUND OR COMPLETED ORDER SOUND
					
func handle_start_interaction_input():
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"furnace":
				var furnace = tilemap.furnaces.filter(func (f): return f.area == interactable).front()
				if furnace.recipes.has(furnace.recipe) && !furnace.smelting:
					$LightFurnace.play()
					tilemap.get_node("Furnaces").get_node("Furnace" + str(furnace.id)).get_node("FurnaceAnimation").visible = true
					print("Starting smelting for " + furnace.recipe)
					furnace.toast.clear()
					furnace.smelting = true
					furnace.timer = create_timer()
					furnace.timer.connect("timeout", furnace_timer_timeout.bind(furnace))
					furnace.timer.run_time = furnace_time
					add_child(furnace.timer)
					furnace.timer.start()
					$HeatFurnace.playing = true
					furnace.timer.position = get_location_from_group(group, furnace.tile) - furnace.timer_position
					


func get_location_from_group(group: String, tile: Vector2) -> Vector2:
	if !tile:
		tile = tilemap.get_used_cells_by_id(atlas_layers.get(group), atlas_ids.get(group), atlas_coords.get(group))[0]
	if tile:
		if group == "anvil":
			return tilemap.map_to_local(tile)
		else:
			return tilemap.map_to_local(tile) - Vector2(0, -10)
	else:
		return Vector2(0, 0)

func furnace_timer_timeout(_id: String, furnace):
	$HeatFurnace.playing = false
	tilemap.get_node("Furnaces").get_node("Furnace" + str(furnace.id)).get_node("FurnaceAnimation").visible = false
	var itemToSpawn = furnace.recipe
	furnace.inventory = [furnace.recipe]
	remove_child(furnace.timer)
	spawn_finished_item(itemToSpawn, furnace)
	furnace.timer = null
	

func clear_interactable(interactable):
	$GrabItem.playing = true
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
	var node = Sprite2D.new()
	node.texture = WantBubbleFactory.get_tex(item)
	add_child(node)
	heldItem = node
	node.add_to_group(item)
	node.scale = item_scales.get(item)
	node.y_sort_enabled = false
	node.z_index = 2
	if item.ends_with("sword") || item.ends_with("staff") || item.ends_with("blade"):
		node.rotation_degrees = 90
	node.position = $Marker2D.position

func spawn_finished_item(item: String, interactable):
	var node = Sprite2D.new()
	node.texture = WantBubbleFactory.get_tex(item)
	add_child(node)
	node.scale = item_scales.get(item)
	node.z_index = 6
	node.y_sort_enabled = false
	node.position = interactable.toast.position
	node.top_level = true
	print(item)
	if item.ends_with("sword") || item.ends_with("staff") || item.ends_with("blade"):
		node.rotation_degrees = 90
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

func start_level():
	set_immobile(false)

func end_level():
	set_immobile(true)

func _physics_process(_delta) -> void:
	if !immobile:
		basic_movement()
		show_interact_button()
	
func set_immobile(true_or_false):
	immobile = true_or_false
	
func _process(_delta) -> void:
	if immobile:
		return
	if Input.is_action_just_pressed("interaction"):
		handle_interaction_input()
	if Input.is_action_just_pressed("start_block"):
		handle_start_interaction_input()
	



