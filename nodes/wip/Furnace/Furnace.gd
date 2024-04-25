extends Area2D
class_name Furnace

# Define the states of this block
enum FurnaceState {
	IDLE,
	SMELTING,
	SMELTED
}

@export var flip_horizontally: bool = false

@onready var collision: CollisionPolygon2D = get_node("CollisionShape")
# In the future these two will be merged into a single animatedsprite2d
@onready var sprite: Sprite2D = get_node("Sprite")
@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var toast: Node2D = get_node("InventoryToast")

var type: Enums.StationType = Enums.StationType.FURNACE
var inventory: PackedStringArray = PackedStringArray([])
var max_size: int = 3
var recipes: Array[Recipe] = []
var state: FurnaceState = FurnaceState.IDLE

var allowed_items: PackedStringArray = PackedStringArray(["gold_ore", "diamond_ore", "bronze_ore"])

func interact(player: Blacksmith, input: StringName) -> bool:
	match input:
		&"interaction":
			match state:
				FurnaceState.IDLE:
					if player.heldItem == null:
						if !is_empty():
							var item = remove_first_item()
							player.equip_item(item)
							return true
					else:
						if inventory.size() == max_size:
							return false
						
						var item = player.heldItem.get_groups()[0]
						
						if !allowed_items.has(item):
							return false
						
						if !Array(inventory).all(func(r): return r == item):
							return false
						
						add_item(item)
						player.unequip_item()
						return true
				FurnaceState.SMELTED:
					var recipe = find_recipe()
					if recipe != null:
						var item = recipe.product
						inventory = []
						player.equip_item(item)
						return true
		&"start_block":
			if state == FurnaceState.IDLE:
				var recipe = find_recipe()
				if recipe != null:
					print("Starting Smelting")
					state = FurnaceState.SMELTING
					await get_tree().create_timer(5).timeout
					print("Finished Smelting")
					state = FurnaceState.SMELTED
					return true

	return false
				
func add_item(item: StringName) -> void:
	inventory.append(item)
	toast.add_material(item)
	
func remove_item() -> StringName:
	return &"HELLO"
	pass

func remove_first_item() -> StringName:
	var item = inventory[0]
	inventory = inventory.slice(1)
	update_toast()
	return item

func update_toast():
	toast.clear()
	for item in inventory:
		toast.add_material(item)
	
func is_empty():
	return inventory.size() == 0

func find_recipe() -> Recipe:
	for recipe in recipes:
		if recipe.ingredients == inventory:
			return recipe
	return null
		

# Called when the node enters the scene tree for the first time.
func _ready():
	if flip_horizontally:
		flip_station()
		
	var recipe = Recipe.new()
	recipe.add_ingredient(&"bronze_ore")
	recipe.add_ingredient(&"bronze_ore")
	recipe.add_ingredient(&"bronze_ore")
	recipe.product = &"bronze_shield_chunk"
	
	recipes.append(recipe)

func flip_station():
	var collision = get_node("CollisionShape")
	collision.scale.x = collision.scale.x * -1
	sprite.flip_h = true
	animation.flip_h = true
