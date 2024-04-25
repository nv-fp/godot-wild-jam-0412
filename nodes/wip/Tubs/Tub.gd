extends Area2D
class_name Tub

# Define the states of this block
enum TubState {
	IDLE,
	QUENCHING,
	QUENCHED
}

@export var flip_horizontally: bool = false

@onready var collision: CollisionPolygon2D = get_node("CollisionShape")
# In the future these two will be merged into a single animatedsprite2d
@onready var sprite: Sprite2D = get_node("Sprite")
@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var toast: Node2D = get_node("InventoryToast")

var type: Enums.StationType = Enums.StationType.TUB
var inventory: PackedStringArray = PackedStringArray([])
var max_size: int = 1
var recipes: Array[Recipe] = []
var state: TubState = TubState.IDLE

var allowed_items: RegEx = RegEx.new()

func interact(player: Blacksmith, input: StringName) -> bool:
	match input:
		&"interaction":
			match state:
				TubState.IDLE:
					if player.heldItem == null:
						if !is_empty():
							var item = remove_first_item()
							player.equip_item(item)
							return true
					else:
						if inventory.size() == max_size:
							return false
						
						var item = player.heldItem.get_groups()[0]
						
						if allowed_items.search(item).strings.size() == 0:
							return false
						
						add_item(item)
						player.unequip_item()
						state = TubState.QUENCHING
						
						var recipe = find_recipe()
						if recipe != null:
							print("Starting Quenching")
							await get_tree().create_timer(5).timeout
							print("Finished Quenching")
							state = TubState.QUENCHED
							return true
				TubState.QUENCHED:
					var recipe = find_recipe()
					if recipe != null:
						var item = recipe.product
						inventory = []
						player.equip_item(item)
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
		
	allowed_items.compile("\\b\\w+(sword|staff|shield)\\b")
	
	var recipe = Recipe.new()
	recipe.add_ingredient(&"bronze_shield")
	recipe.product = &"polished_bronze_shield"
	
	recipes.append(recipe)

func flip_station():
	var collision = get_node("CollisionShape")
	collision.scale.x = collision.scale.x * -1
	sprite.flip_h = true
	animation.flip_h = true
