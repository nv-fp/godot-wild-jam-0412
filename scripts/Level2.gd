extends TileMap

var crate_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(35, 0), Vector2(35, -3), Vector2(29, 3), Vector2(27, 3)])
var anvil_collision_tile: Vector2 = Vector2(25, -3)
var furnace_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(30, -5), Vector2(26, -5)])
var trash_collision_tile: Vector2 = Vector2(25, 1)
var table_collision_tile: Vector2 = Vector2(35, 2)
var tub_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(31, 3), Vector2(34, -5)])

var tub_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(19, 30), Vector2(-10, 40)])
var tub_item_offsets: PackedVector2Array = PackedVector2Array([Vector2(-7, -10), Vector2(25, -26)])

var groupNames = ["Bronze_Ore", "Gold_Ore", "Diamond_Ore", "Leather_Hide"]
var furnaces = []
var anvils = []
var tables = []
var tubs = []

var mat_toast = preload('res://nodes/ui/MaterialToast.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = $Blacksmith.position

	for i in range(crate_collision_tiles.size()):
		var area: Area2D = create_collision_for_single_tile(crate_collision_tiles[i])
		area.body_entered.connect(area_entered.bind(area))
		area.body_exited.connect(area_exited.bind(area))
		
		area.add_to_group(groupNames[i])
		add_child(area)
	
	var anvil_area = create_collision_for_anvil(anvil_collision_tile)
	anvil_area.add_to_group("Anvil")
	anvil_area.body_entered.connect(area_entered.bind(anvil_area))
	anvil_area.body_exited.connect(area_exited.bind(anvil_area))
	add_child(anvil_area)
	
	var anvil_toast = mat_toast.instantiate()
	add_child(anvil_toast)
	anvil_toast.position = map_to_local(anvil_collision_tile) + Vector2(-23, -32)
	
	anvils.append({
		"tile": anvil_collision_tile,
		"recipe": null,
		"smithing": false,
		"timer": null,
		"area": anvil_area,
		"inventory": [],
		"recipes": {
			"Bronze_Shield": ["Bronze_Shield_Chunk"],
			"Gold_Shield": ["Gold_Shield_Chunk"],
			"Diamond_Shield": ["Diamond_Shield_Chunk"],
			"Bronze_Blade": ["Bronze_Blade_Chunk"],
			"Gold_Blade": ["Gold_Blade_Chunk"],
			"Diamond_Blade": ["Diamond_Blade_Chunk"]
		},
		"toast": anvil_toast,
		"timer_position": Vector2(37, 40)
	})
	
	for i in range(furnace_collision_tiles.size()):
		var furnace_area = create_collision_for_furnace(furnace_collision_tiles[i])
		furnace_area.add_to_group("Furnace")
		furnace_area.body_entered.connect(area_entered.bind(furnace_area))
		furnace_area.body_exited.connect(area_exited.bind(furnace_area))
		add_child(furnace_area)
		
		var toast = mat_toast.instantiate()
		add_child(toast)
		toast.position = map_to_local(furnace_collision_tiles[i]) + Vector2(10, -34)

		furnaces.append({
			"tile": furnace_collision_tiles[i],
			"recipe": null,
			"smelting": false,
			"timer": null,
			"area": furnace_area,
			"inventory": [],
			"recipes": {
				"Bronze_Shield_Chunk": ["Bronze_Ore", "Bronze_Ore", "Bronze_Ore"],
				"Gold_Shield_Chunk": ["Gold_Ore", "Gold_Ore", "Gold_Ore"],
				"Diamond_Shield_Chunk": ["Diamond_Ore", "Diamond_Ore", "Diamond_Ore"],
				"Bronze_Blade_Chunk": ["Bronze_Ore", "Bronze_Ore"],
				"Gold_Blade_Chunk": ["Gold_Ore", "Gold_Ore"],
				"Diamond_Blade_Chunk": ["Diamond_Ore", "Diamond_Ore"]
			},
			"toast": toast,
			"timer_position": Vector2(0, 45)
		})
	
	var table_area = create_collision_for_table(table_collision_tile)
	table_area.add_to_group("Craft")
	table_area.body_entered.connect(area_entered.bind(table_area))
	table_area.body_exited.connect(area_exited.bind(table_area))
	add_child(table_area)
	
	var table_toast = mat_toast.instantiate()
	add_child(table_toast)
	table_toast.position = map_to_local(table_collision_tile) + Vector2(-10, -20)
	
	tables.append({
		"tile": table_collision_tile,
		"recipe": null,
		"crafting": false,
		"timer": null,
		"area": table_area,
		"inventory": [],
		"recipes": {
			"Bronze_Sword": ["Bronze_Blade", "Leather_Hide"],
			"Gold_Sword": ["Gold_Blade", "Leather_Hide"],
			"Diamond_Sword": ["Diamond_Blade", "Leather_Hide"]
		},
		"toast": table_toast,
		"timer_position": Vector2(0, 30)
	})
	
	var trash_area = create_collision_for_single_tile(trash_collision_tile)
	trash_area.add_to_group("Trash")
	trash_area.body_entered.connect(area_entered.bind(trash_area))
	trash_area.body_exited.connect(area_exited.bind(trash_area))
	add_child(trash_area)
	
	for i in range(tub_collision_tiles.size()):
		var tub_area = create_collision_for_tub(tub_collision_tiles[i])
		tub_area.add_to_group("Tub")
		tub_area.body_entered.connect(area_entered.bind(tub_area))
		tub_area.body_exited.connect(area_exited.bind(tub_area))
		add_child(tub_area)
		
		var tub_toast = mat_toast.instantiate()
		add_child(tub_toast)
		tub_toast.position = map_to_local(tub_collision_tiles[i]) + tub_item_offsets[i]
	
		tubs.append({
			"tile": tub_collision_tiles[i],
			"recipe": null,
			"polishing": false,
			"timer": null,
			"area": tub_area,
			"inventory": [],
			"recipes": {
				"Polished_Bronze_Shield": ["Bronze_Shield"],
				"Polished_Gold_Shield": ["Gold_Shield"],
				"Polished_Diamond_Shield": ["Diamond_Shield"],
				"Polished_Bronze_Sword": ["Bronze_Sword"],
				"Polished_Gold_Sword": ["Gold_Sword"],
				"Polished_Diamond_Sword": ["Diamond_Sword"]
			},
			"toast": tub_toast,
			"timer_position": tub_timer_offsets[i]
		})

# Create Area2D on tile
func create_collision_for_single_tile(coordinates: Vector2) -> Area2D:
	var tile_position: Vector2 = map_to_local(coordinates)
	var top: Vector2 = tile_position + Vector2(0, -12 / 2)
	var left: Vector2 = tile_position + Vector2(-28 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(0, 12 / 2)
	var right: Vector2 = tile_position + Vector2(28 / 2, 0)
	var area: Area2D = Area2D.new()
	area.z_index = 1
	var collision_shape: CollisionPolygon2D = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	collision_shape.set_polygon(PackedVector2Array([top, left, bottom, right]))
	return area

func create_collision_for_anvil(coordinates: Vector2) -> Area2D:
	var tile_position: Vector2 = map_to_local(coordinates)
	var top: Vector2 = tile_position + Vector2(0, -16 / 2)
	var left: Vector2 = tile_position + Vector2(-16, 16 / 2) + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(-16, 16 / 2) + Vector2(0, 16 / 2)
	var right: Vector2 = tile_position + Vector2(32 / 2, 0)
	var area: Area2D = Area2D.new()
	area.z_index = 1
	var collision_shape: CollisionPolygon2D = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	collision_shape.set_polygon(PackedVector2Array([top, left, bottom, right]))
	return area

func create_collision_for_furnace(coordinates: Vector2) -> Area2D:
	var tile_position: Vector2 = map_to_local(coordinates)
	var top: Vector2 = tile_position - Vector2(16, 16 / 2) + Vector2(0, -16 / 2)
	var left: Vector2 = tile_position - Vector2(16, 16 / 2) + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(16, 16 / 2) + Vector2(0, 16 / 2)
	var right: Vector2 = tile_position + Vector2(16, 16 / 2) + Vector2(32 / 2, 0)
	var area: Area2D = Area2D.new()
	area.z_index = 1
	var collision_shape: CollisionPolygon2D = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	collision_shape.set_polygon(PackedVector2Array([top, left, bottom, right]))
	return area

func create_collision_for_table(coordinates: Vector2) -> Area2D:
	var tile_position: Vector2 = map_to_local(coordinates)
	var top: Vector2 = tile_position + Vector2(0, -16 / 2)
	var left: Vector2 = tile_position + Vector2(-16, 16 / 2) + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(-16, 16 / 2) + Vector2(0, 16 / 2)
	var right: Vector2 = tile_position + Vector2(32 / 2, 0)
	var area: Area2D = Area2D.new()
	area.z_index = 1
	var collision_shape: CollisionPolygon2D = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	collision_shape.set_polygon(PackedVector2Array([top, left, bottom, right]))
	return area

func create_collision_for_tub(coordinates: Vector2) -> Area2D:
	var tile_position: Vector2 = map_to_local(coordinates)
	var top: Vector2 = tile_position  + Vector2(0, -16 / 2)
	var left: Vector2 = tile_position + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(16, 16 / 2) + Vector2(0, 16 / 2)
	var right: Vector2 = tile_position + Vector2(16, 16 / 2) + Vector2(32 / 2, 0)
	var area: Area2D = Area2D.new()
	area.z_index = 1
	var collision_shape: CollisionPolygon2D = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	collision_shape.set_polygon(PackedVector2Array([top, left, bottom, right]))
	return area

# Old Triggger for entering a crates area2d
func area_entered(node: Node2D, emitter: Area2D):
	# Area2D colliding with something, check if our node is the blacksmith
	# so that we don't prematurely set z_index
	if node != $Blacksmith:
		return
	$Blacksmith.interactable = emitter

# Old Trigger for exiting a crates area2d
func area_exited(node: Node2D, emitter: Area2D):
	$Blacksmith.interactable = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This should be moved to Blacksmith eventually probably
func _process(_delta):
	pass
	#$Camera2D.position = $Blacksmith.position

# Dirty hack for z_index clipping
func _on_area_2d_body_entered(body):
	if body == $Blacksmith:
		$Blacksmith.z_index = 4

func _on_area_2d_body_exited(body):
	if body == $Blacksmith:
		$Blacksmith.z_index = 1
