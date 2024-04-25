extends Node

class_name Recipe

# The ingredients needed for this recipe
var ingredients: PackedStringArray = PackedStringArray([])

# The end product this recipe produces
var product: StringName

# The time it takes for this recipe to complete (in seconds)
var time: float;

# Add an ingredient to the recipe
func add_ingredient(item: StringName) -> void:
	ingredients.append(item)

# Remove an ingredient from the recipe
func remove_ingredient():
	pass
	
