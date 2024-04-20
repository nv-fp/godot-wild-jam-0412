extends TileMap

var crate_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(32, -1), Vector2(32, -3), Vector2(32, -5)])
var anvil_collision_tile: Vector2 = Vector2(25, -5)
var furnace_collision_tile: Vector2 = Vector2(28, -5)
var trash_collision_tile: Vector2 = Vector2(25, -3)
var tub_collision_tile: Vector2 = Vector2(29, -1)
var groupNames = ["bronze_ore", "gold_ore", "diamond_ore"]

var furnaces = []
var anvils = []
var tubs = []

var mat_toast = preload("res://nodes/ui/MaterialToast.tscn")

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
	anvil_area.add_to_group("anvil")
	anvil_area.body_entered.connect(area_entered.bind(anvil_area))
	anvil_area.body_exited.connect(area_exited.bind(anvil_area))
	add_child(anvil_area)
	
	var anvil_toast = mat_toast.instantiate()
	add_child(anvil_toast)
	anvil_toast.position = map_to_local(anvil_collision_tile) + Vector2(10, -40)
	
	anvils.append({
		"tile": anvil_collision_tile,
		"recipe": null,
		"smithing": false,
		"timer": null,
		"area": anvil_area,
		"inventory": [],
		"id": "Anvil",
		"recipes": {
			"bronze_shield": ["bronze_shield_chunk"],
			"gold_shield": ["gold_shield_chunk"],
			"diamond_shield": ["diamond_shield_chunk"]
		},
		"toast": anvil_toast,
		"timer_position": Vector2(5, 40)
	})
	
	var furnace_area = create_collision_for_furnace(furnace_collision_tile)
	furnace_area.add_to_group("furnace")
	furnace_area.body_entered.connect(area_entered.bind(furnace_area))
	furnace_area.body_exited.connect(area_exited.bind(furnace_area))
	add_child(furnace_area)
	
	var furnace_toast = mat_toast.instantiate()
	add_child(furnace_toast)
	furnace_toast.position = map_to_local(furnace_collision_tile) + Vector2(10, -34)
	
	furnaces.append({
		"id": 0,
		"tile": furnace_collision_tile,
		"recipe": null,
		"smelting": false,
		"timer": null,
		"area": furnace_area,
		"inventory": [],
		"recipes": {
			"bronze_shield_chunk": ["bronze_ore", "bronze_ore", "bronze_ore"],
			"gold_shield_chunk": ["gold_ore", "gold_ore", "gold_ore"],
			"diamond_shield_chunk": ["diamond_ore", "diamond_ore", "diamond_ore"],
		},
		"toast": furnace_toast,
		"timer_position": Vector2(0, 55)
	})
	
	var trash_area = create_collision_for_single_tile(trash_collision_tile)
	trash_area.add_to_group("trash")
	trash_area.body_entered.connect(area_entered.bind(trash_area))
	trash_area.body_exited.connect(area_exited.bind(trash_area))
	add_child(trash_area)
	
	$DeliveryArea.body_entered.connect(area_entered.bind($DeliveryArea))
	$DeliveryArea.body_exited.connect(area_exited.bind($DeliveryArea))
	
	var tub_area = create_collision_for_tub(tub_collision_tile)
	tub_area.add_to_group("tub")
	tub_area.body_entered.connect(area_entered.bind(tub_area))
	tub_area.body_exited.connect(area_exited.bind(tub_area))
	add_child(tub_area)
		
	var tub_toast = mat_toast.instantiate()
	add_child(tub_toast)
	tub_toast.position = map_to_local(tub_collision_tile) + Vector2(-7, -10)
	
	tubs.append({
		"tile": tub_collision_tile,
		"recipe": null,
		"polishing": false,
		"timer": null,
		"area": tub_area,
		"inventory": [],
		"recipes": {
			"polished_bronze_shield": ["bronze_shield"],
			"polished_gold_shield": ["gold_shield"],
			"polished_diamond_shield": ["diamond_shield"],
		},
		"toast": tub_toast,
		"timer_position": Vector2(19, 30)
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
	var top: Vector2 = tile_position - Vector2(16, 16 / 2) + Vector2(0, -16 / 2)
	var left: Vector2 = tile_position - Vector2(16, 16 / 2) + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(0, 16 / 2)
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
	var left: Vector2 = tile_position + Vector2(-32 / 2 , 0)
	var bottom: Vector2 = tile_position + Vector2(0, 16 / 2)
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




# Dirty hack to get z_index clipping working
func _on_area_2d_body_entered(body):
	if body == $Blacksmith:
		#var tile_data = get_cell_tile_data(2, Vector2(31, -5))
		#tile_data.z_index = 6
		$Blacksmith.z_index = 5


func _on_area_2d_body_exited(body):
	if body == $Blacksmith:
		#var tile_data = get_cell_tile_data(2, Vector2(31, -5))
		#tile_data.z_index = 1
		$Blacksmith.z_index = 1
