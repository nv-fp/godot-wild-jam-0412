extends TileMap

var crate_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(35, 0), Vector2(35, -3), Vector2(29, 3), Vector2(26, 3)])
var anvil_collision_tile: Vector2 = Vector2(25, -3)
var furnace_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(30, -5), Vector2(26, -5)])
var trash_collision_tile: Vector2 = Vector2(25, 1)
var table_collision_tile: Vector2 = Vector2(35, 2)
var tub_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(31, 3), Vector2(34, -5)])

var tub_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(19, 30), Vector2(-10, 40)])
var tub_item_offsets: PackedVector2Array = PackedVector2Array([Vector2(-7, -10), Vector2(25, -26)])

var counter = {
	"layer": 1,
	"atlas": 15,
	"coordinates": [Vector2(0, 0), Vector2(0, 1)]
}

# RAYCAST STUFF
var tub_tiles = [Vector2i(30, 3), Vector2i(33, -7)]
var anvil_tile = Vector2i(22, -4)

var groupNames = ["bronze_ore", "gold_ore", "diamond_ore", "leather_hide"]
var crates = []
var furnaces = []
var anvils = []
var tables = []
var tubs = []

var mat_toast = preload('res://nodes/ui/MaterialToast.tscn')


var counterscene = preload("res://nodes/wip/Counter.tscn")
var counters: Array[Counter] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_storage_counters()
	
func create_storage_counters():
	var tiles = []
	tiles.append_array(get_used_cells_by_id(counter.layer, counter.atlas, counter.coordinates[0]))
	tiles.append_array(get_used_cells_by_id(counter.layer, counter.atlas, counter.coordinates[1]))
	
	for tile in tiles:
		var alternate_id = get_cell_alternative_tile(counter.layer, tile)
		var data = get_cell_tile_data(counter.layer, tile)
		var counter2 = counterscene.instantiate()
		add_child(counter2)
		counter2.tile = tile
		counter2.position = map_to_local(tile)
		if alternate_id & TileSetAtlasSource.TRANSFORM_FLIP_H:
			counter2.flip()
		counters.append(counter2)
		set_cell(counter.layer, tile, -1, Vector2i(-1, -1))
	
	print("Created "  + str(counters.size()) + " counters")

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

func pause():
	$Blacksmith.pause_game()

func unpause():
	$Blacksmith.resume_game()
