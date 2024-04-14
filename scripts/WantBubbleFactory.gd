extends Node

class_name WantBubbleFactory

static func new_sword(id: String):
	var wb_scene = preload('res://nodes/ui/WantBubble.tscn')
	var wb = wb_scene.instantiate()
	var sword_tex = load('res://art/sword.png')
	var mat_atlas_base = load('res://art/materials.png')
	
	var ore_tex = AtlasTexture.new()
	ore_tex.atlas = mat_atlas_base
	ore_tex.set_region(Rect2(32, 0, 32, 32))
	
	var wood_tex = AtlasTexture.new()
	wood_tex.atlas = mat_atlas_base
	wood_tex.set_region(Rect2(0, 0, 32, 32))
	
	wb.item_tex = sword_tex
	wb.part_a_tex = ore_tex
	wb.part_b_tex = wood_tex
	
	wb.id = id
	wb.complete_time_ms = 4500

	return wb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
