extends TileMap

var crateCollisionTiles: PackedVector2Array = PackedVector2Array([Vector2(31, -1), Vector2(31, -3), Vector2(31, -5)])
var anvilCollisionTile: Vector2 = Vector2(25, -5)
var furnaceCollisionTile: Vector2 = Vector2(28, -5)
var groupNames = ["Bronze_Ore", "Gold_Ore", "Diamond_Ore"]
var canInteract = false
var interactables = []

var furnaces = []
var anvils = []



# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = $Blacksmith.position
	var interactables = []
	
	interactables.append_array(crateCollisionTiles)
	
	for i in range(crateCollisionTiles.size()):
		var area: Area2D = create_collision_for_single_tile(crateCollisionTiles[i])
		area.body_entered.connect(area_entered.bind(area))
		area.body_exited.connect(area_exited.bind(area))
		
		area.add_to_group(groupNames[i])
		add_child(area)
	
	var anvilArea = create_collision_for_anvil(anvilCollisionTile)
	anvilArea.add_to_group("Anvil")
	anvilArea.body_entered.connect(area_entered.bind(anvilArea))
	anvilArea.body_exited.connect(area_exited.bind(anvilArea))
	add_child(anvilArea)
	
	anvils.append({
		"recipe": null,
		"smithing": false,
		"timer": null,
		"area": anvilArea,
		"inventory": [],
		"id": "Anvil"
	})
	
	var furnaceArea = create_collision_for_furnace(furnaceCollisionTile)
	furnaceArea.add_to_group("Furnace")
	furnaceArea.body_entered.connect(area_entered.bind(furnaceArea))
	furnaceArea.body_exited.connect(area_exited.bind(furnaceArea))
	add_child(furnaceArea)
	
	furnaces.append({
		"recipe": null,
		"smelting": false,
		"timer": null,
		"area": furnaceArea,
		"inventory": [],
		"id": "Furnace"
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

# Old Triggger for entering a crates area2d
func area_entered(node: Node2D, emitter: Area2D):
	# Area2D colliding with something, check if our node is the blacksmith
	# so that we don't prematurely set z_index
	if node != $Blacksmith:
		return
	$Blacksmith.interactable = emitter
	if (emitter.get_groups()[0] == "Furnace"):
		$Blacksmith.z_index = 4

# Old Trigger for exiting a crates area2d
func area_exited(node: Node2D, emitter: Area2D):
	$Blacksmith.interactable = null
	if (emitter.get_groups()[0] == "Furnace"):
		$Blacksmith.z_index = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This should be moved to Blacksmith eventually probably
func _process(_delta):
	$Camera2D.position = $Blacksmith.position

