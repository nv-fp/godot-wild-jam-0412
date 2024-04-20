extends TileMap

var crate_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(35, 0), Vector2(35, -3), Vector2(29, 3), Vector2(27, 3)])
var anvil_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(25, -1), Vector2(25, -4)])
var furnace_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(25, 3), Vector2(31, -5), Vector2(37, -5)])
var trash_collision_tile: Vector2 = Vector2(25, 1)
var table_collision_tile: PackedVector2Array = PackedVector2Array([Vector2(31, 6), Vector2(40, 4)])
var tub_collision_tiles: PackedVector2Array = PackedVector2Array([Vector2(32, 3), Vector2(32, -2)])

var furnace_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(20, 60), Vector2(0, 60), Vector2(0, 60)])
var table_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(15, 30), Vector2(-10, 30)])
var tub_timer_offsets: PackedVector2Array = PackedVector2Array([Vector2(-15, 40), Vector2(15, 20)])

var groupNames = ["bronze_ore", "gold_ore", "diamond_ore", "leather_hide", "wood"]
var furnaces = []
var anvils = []
var tables = []
var tubs = []

var mat_toast = preload('res://nodes/ui/MaterialToast.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range($Crates.get_child_count()):
		var area: Area2D = $Crates.get_node(groupNames[i])
		area.body_entered.connect(area_entered.bind(area))
		area.body_exited.connect(area_exited.bind(area))
		
		area.add_to_group(groupNames[i])
	
	for i in range($Anvils.get_child_count()):
		var anvil_area = $Anvils.get_node("Anvil" + str(i))
		anvil_area.add_to_group("anvil")
		anvil_area.body_entered.connect(area_entered.bind(anvil_area))
		anvil_area.body_exited.connect(area_exited.bind(anvil_area))
	
		var anvil_toast = mat_toast.instantiate()
		add_child(anvil_toast)
		anvil_toast.position = map_to_local(anvil_collision_tiles[i]) + Vector2(-5, -42)
	
		anvils.append({
			"tile": anvil_collision_tiles[i],
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
				"diamond_blade": ["diamond_blade_chunk"],
				"bronze_gem": ["bronze_gem_chunk"],
				"gold_gem": ["gold_gem_chunk"],
				"diamond_gem": ["diamond_gem_chunk"]
			},
			"toast": anvil_toast,
			"timer_position": Vector2(20, 45)
		})
	
	for i in range($Furnaces.get_child_count()):
		var furnace: Node2D = $Furnaces.get_node("Furnace" + str(i))
		var furnace_area = furnace.get_node("Area")
		furnace_area.add_to_group("furnace")
		furnace_area.body_entered.connect(area_entered.bind(furnace_area))
		furnace_area.body_exited.connect(area_exited.bind(furnace_area))
		
		var toast = mat_toast.instantiate()
		add_child(toast)
		toast.position = furnace.get_node("ToastPosition").position

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
				"diamond_blade_chunk": ["diamond_ore", "diamond_ore"],
				"bronze_gem_chunk": ["bronze_ore"],
				"gold_gem_chunk": ["gold_ore"],
				"diamond_gem_chunk": ["diamond_ore"]
			},
			"toast": toast,
			"timer_position": furnace_timer_offsets[i]
		})
	
	for i in range($Tables.get_child_count()):
		var table = $Tables.get_node("Table" + str(i))
		var table_area = table.get_node("Area")
		table_area.add_to_group("craft")
		table_area.body_entered.connect(area_entered.bind(table_area))
		table_area.body_exited.connect(area_exited.bind(table_area))
	
		var table_toast = mat_toast.instantiate()
		add_child(table_toast)
		table_toast.position = table.get_node("ToastPosition").position
	
		tables.append({
			"tile": table_collision_tile[i],
			"recipe": null,
			"crafting": false,
			"timer": null,
			"area": table_area,
			"inventory": [],
			"recipes": {
				"bronze_sword": ["bronze_blade", "leather_hide"],
				"gold_sword": ["gold_blade", "leather_hide"],
				"diamond_sword": ["diamond_blade", "leather_hide"],
				"bronze_staff": ["bronze_gem", "wood"],
				"gold_staff": ["gold_gem", "wood"],
				"diamond_staff": ["diamond_gem", "wood"]
			},
			"toast": table_toast,
			"timer_position": table_timer_offsets[i]
		})
	
	# Hook up our Delivery Area
	$DeliveryArea.body_entered.connect(area_entered.bind($DeliveryArea))
	$DeliveryArea.body_exited.connect(area_exited.bind($DeliveryArea))
	
	# Come back and add trash area after everything else
	var trash_area = $Trash.get_node("Area2D")
	trash_area.add_to_group("trash")
	trash_area.body_entered.connect(area_entered.bind(trash_area))
	trash_area.body_exited.connect(area_exited.bind(trash_area))
	
	for i in range($Tubs.get_child_count()):
		var tub = $Tubs.get_node("Tubs" + str(i))
		var tub_area = tub.get_node("Area")
		tub_area.add_to_group("tub")
		tub_area.body_entered.connect(area_entered.bind(tub_area))
		tub_area.body_exited.connect(area_exited.bind(tub_area))
		
		var tub_toast = mat_toast.instantiate()
		add_child(tub_toast)
		tub_toast.position = tub.get_node("ToastPosition").position
	
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
				"polished_diamond_sword": ["diamond_sword"],
				"polished_bronze_staff": ["bronze_staff"],
				"polished_gold_staff": ["gold_staff"],
				"polished_diamond_staff": ["diamond_staff"]
			},
			"toast": tub_toast,
			"timer_position": tub_timer_offsets[i]
		})

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
