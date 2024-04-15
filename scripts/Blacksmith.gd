extends CharacterBody2D

# We can also export this and set in the designer
# but the character will be a parent of the tilemap for y-sorting to work properly
@onready var tilemap: TileMap = get_parent()
@export var speed: int = 100

var scenes = {
	"Bronze": preload("res://nodes/items/Bronze.tscn"),
	"Gold": preload("res://nodes/items/Gold.tscn"),
	"Diamond": preload("res://nodes/items/Diamond.tscn")
}

var pickedUpItem = false
var heldItem: Node2D
var interactable: Area2D

var smithingItem = false

var directions: PackedStringArray = PackedStringArray(["east", "south_east", "south", "south_west", "west", "north_west", "north", "north_east"])
var last_direction: String = "south"
var last_direction_vector: Vector2 = Vector2(0, 1)

func basic_movement():
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var angle: float = input_direction.angle()
	var step: int = snapped(angle, PI/4) / (PI/4)
	var index: int = wrapi(int(step), 0, 8)	
	if input_direction.length() != 0:
		$AnimatedSprite2D.animation = directions[index]
		last_direction = directions[index]
		last_direction_vector = input_direction
	else:
		$AnimatedSprite2D.animation = "idle_" + last_direction
		
	$AnimatedSprite2D.play()	
	velocity = input_direction * speed
	move_and_slide()
	
	
func show_interact_button():
	if interactable:
		var tile = tilemap.local_to_map(interactable.position)
		if tile:
			$InteractPrompt.visible = true
			$InteractPrompt.position = tilemap.map_to_local(tile)
		else:
			$InteractPrompt.visible = false
	else:
		$InteractPrompt.visible = false

func handleInteractionInput() -> void:
	if interactable:
		var group = interactable.get_groups()[0]
		match group:
			"Diamond","Gold","Bronze":
				if heldItem != null:
					return
				pickedUpItem = true
				var sceneToCreate = scenes.get(group)
				var node = sceneToCreate.instantiate()
				heldItem = node
				add_child(node)
				node.scale.x = 0.75
				node.scale.y = 0.75
				node.y_sort_enabled = false
				node.z_index = 2
				node.position = $Marker2D.position
			"Anvil":
				print("Anvil")

func _physics_process(_delta) -> void:
	basic_movement()
	show_interact_button()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("interaction"):
		handleInteractionInput()
	


