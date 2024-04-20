extends TileMap

var crate_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(35, 0), Vector2(35, -3), Vector2(29, 3), Vector2(27, 3)])
var anvil_collision_tile: Vector2 = Vector2(25, -3)
var furnace_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(30, -5), Vector2(26, -5)])
var trash_collision_tile: Vector2 = Vector2(25, 1)
var table_collision_tile: Vector2 = Vector2(35, 2)
var tub_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(31, 3), Vector2(34, -5)])

var tub_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(19, 30), Vector2(-10, 40)])
var tub_item_offsets: PackedVector2Array = PackedVector2Array([Vector2(-7, -10), Vector2(25, -26)])

var groupNames = ["bronze_ore", "gold_ore", "diamond_ore", "leather_hide"]
var furnaces = []
var anvils = []
var tables = []
var tubs = []

var mat_toast = preload('res://nodes/ui/MaterialToast.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(crate_collision_tiles.size()):
		var area: Area2D = create_collision_for_single_tile(crate_collision_tiles[i])
		area.body_entered.connect(area_entered.bind(area))
		area.body_exited.connect(area_exited.bind(area))
		
		area.add_to_group(groupNames[i])
		add_child(area)
	
	var anvil_area = create_collision_for_anvil(anvil_collision_tile)
	anvil_area.add_to_group("anvil")
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
			"bronze_shield": ["bronze_shield_chunk"],
			"gold_shield": ["gold_shield_chunk"],
			"diamond_shield": ["diamond_shield_chunk"],
			"bronze_blade": ["bronze_blade_chunk"],
			"gold_blade": ["gold_blade_chunk"],
			"diamond_blade": ["diamond_blade_chunk"]
		},
		"toast": anvil_toast,
		"timer_position": Vector2(37, 40)
	})
	
	for i in range(furnace_collision_tiles.size()):
		var furnace_area = create_collision_for_furnace(furnace_collision_tiles[i])
		furnace_area.add_to_group("furnace")
		furnace_area.body_entered.connect(area_entered.bind(furnace_area))
		furnace_area.body_exited.connect(area_exited.bind(furnace_area))
		add_child(furnace_area)
		
		var toast = mat_toast.instantiate()
		add_child(toast)
		toast.position = map_to_local(furnace_collision_tiles[i]) + Vector2(10, -34)

		furnaces.append({
			"id": i,
			"tile": furnace_collision_tiles[i],
			"recipe": null,
			"smelting": false,
			"timer": null,
			"area": furnace_area,
			"inventory": [],
			"recipes": {
				"bronze_shield_chunk": ["bronze_ore", "bronze_ore", "bronze_ore"],
				"gold_shield_chunk": ["gold_ore", "gold_ore", "gold_ore"],
				"diamond_shield_chunk": ["diamond_ore", "diamond_ore", "diamond_ore"],
				"bronze_blade_chunk": ["bronze_ore", "bronze_ore"],
				"gold_blade_chunk": ["gold_ore", "gold_ore"],
				"diamond_blade_chunk": ["diamond_ore", "diamond_ore"]
			},
			"toast": toast,
			"timer_position": Vector2(0, 55)
		})
	
	var table_area = create_collision_for_table(table_collision_tile)
	table_area.add_to_group("craft")
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
			"bronze_sword": ["bronze_blade", "leather_hide"],
			"gold_sword": ["gold_blade", "leather_hide"],
			"diamond_sword": ["diamond_blade", "leather_hide"]
		},
		"toast": table_toast,
		"timer_position": Vector2(0, 30)
	})
	
	# Setup Delivery Area
	$DeliveryArea.body_entered.connect(area_entered.bind($DeliveryArea))
	$DeliveryArea.body_exited.connect(area_exited.bind($DeliveryArea))
	
	var trash_area = create_collision_for_single_tile(trash_collision_tile)
	trash_area.add_to_group("trash")
	trash_area.body_entered.connect(area_entered.bind(trash_area))
	trash_area.body_exited.connect(area_exited.bind(trash_area))
	add_child(trash_area)
	
	for i in range(tub_collision_tiles.size()):
		var tub_area = create_collision_for_tub(tub_collision_tiles[i])
		tub_area.add_to_group("tub")
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
				"polished_bronze_shield": ["bronze_shield"],
				"polished_gold_shield": ["gold_shield"],
				"polished_diamond_shield": ["diamond_shield"],
				"polished_bronze_sword": ["bronze_sword"],
				"polished_gold_sword": ["gold_sword"],
				"polished_diamond_sword": ["diamond_sword"]
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
	$Camera2D.position = $Blacksmith.position

# Dirty hack for z_index clipping
func _on_area_2d_body_entered(body):
	if body == $Blacksmith:
		$Blacksmith.z_index = 4

func _on_area_2d_body_exited(body):
	if body == $Blacksmith:
		$Blacksmith.z_index = 1

func start_level():
	$Blacksmith.start_level()

func end_level():
	$Blacksmith.end_level()
