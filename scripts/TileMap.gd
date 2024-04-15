extends TileMap

var crateCollisionTiles: PackedVector2Array = PackedVector2Array([Vector2(31, -1), Vector2(31, -3), Vector2(31, -5)])
var anvilCollisionTiles: PackedVector2Array = PackedVector2Array([Vector2(24, -5), Vector2(25, -5), Vector2(26, -5)])
var groupNames = ["Bronze", "Gold", "Diamond", "Anvil", "Anvil", "Anvil"]
var canInteract = false
var interactables = []

var tileToArea = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = $Blacksmith.position
	var interactables = []
	
	interactables.append_array(crateCollisionTiles)
	interactables.append_array(anvilCollisionTiles)
	
	for i in range(interactables.size()):
		var area: Area2D = create_collision_for_tile(interactables[i])
		area.body_entered.connect(area_entered.bind(area))
		area.body_exited.connect(area_exited.bind(area))
		
		area.add_to_group(groupNames[i])
		add_child(area)

# Create Area2D on tile
func create_collision_for_tile(coordinates: Vector2) -> Area2D:
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

# Old Triggger for entering a crates area2d
func area_entered(node: Node2D, emitter: Area2D):
	$Blacksmith.interactable = emitter

# Old Trigger for exiting a crates area2d
func area_exited(node: Node2D, emitter: Area2D):
	$Blacksmith.interactable = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This should be moved to Blacksmith eventually probably
func _process(_delta):
	$Camera2D.position = $Blacksmith.position
	if Input.is_action_just_pressed("drop_item") && $Blacksmith.pickedUpItem == true:
		var node = $Blacksmith.heldItem
		$Blacksmith.pickedUpItem = false
		$Blacksmith.remove_child(node)
		add_child(node)
		node.z_index = 1
		node.y_sort_enabled = true
		node.scale.x = 1
		node.scale.y = 1
		node.position = $Blacksmith.position
