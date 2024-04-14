extends Node

# ensures we only process the configs once
var has_loaded: bool = false
var _item_cfg_file = 'res://config/objects.cfg'
var _atlas_cfg_file = 'res://config/atlas.cfg'

# String -> [String, String, int, int]
# name -> [part_a, part_b, time_ms, point_value]
var object_list = {}

# String -> [String, Rect2]
# name -> [resource path, atlas offset]
var tex_coords = {}

func _load_cfg() -> void:
	if has_loaded:
		return
	_load_textures()
	_load_items()
	has_loaded = true

# loads textures from atlas config file
func _load_textures() -> void:
	var f = FileAccess.open(_atlas_cfg_file, FileAccess.READ)

	while not f.eof_reached():
		var cfg_line = f.get_line().strip_edges()
		if cfg_line.begins_with('#'):
			continue

		if not cfg_line.is_empty():
			var cfg_parts = cfg_line.split(',')
			if cfg_parts.size() != 6:
				print('bad materail: ' + cfg_line)
				continue
			var tex_name = cfg_parts[0].strip_edges()
			var src = cfg_parts[1].strip_edges()
			tex_coords[tex_name] = [
				src,
				Rect2(
					cfg_parts[2] as int, cfg_parts[3] as int,
					cfg_parts[4] as int,cfg_parts[5] as int)
			]
	f.close()

func _load_items() -> void:
	var f = FileAccess.open(_item_cfg_file, FileAccess.READ)

	while not f.eof_reached():
		var cfg_line = f.get_line().strip_edges()
		if cfg_line.begins_with('#'):
			continue

		if not cfg_line.is_empty():
			var cfg_parts = cfg_line.split(',')
			if cfg_parts.size() != 5:
				print('bad item config: ' + cfg_line)
				continue

			var mat1 = cfg_parts[1].strip_edges()
			var mat2 = cfg_parts[2].strip_edges()
			if not tex_coords.has(mat1):
				print('Unknown material: ' + mat1)
				continue
			if not tex_coords.has(mat2):
				print('Unknown material: ' + mat2)
				continue

			object_list[cfg_parts[0]] = [
				mat1, mat2, # components
				cfg_parts[3] as int, # time_ms
				cfg_parts[4] as int, # point_value
			]
	f.close()

# returns ?Array[], i don't think the type system supports this?
func get_object_parts(obj_name: String):
	_load_cfg()
	if object_list.has(obj_name):
		return [
			object_list[obj_name][0],
			object_list[obj_name][1]
		]
	return null

# returns ?int
func get_object_points(obj_name: String):
	_load_cfg()
	if object_list.has(obj_name):
		return object_list[obj_name][3]
	return null

# returns ?int
func get_object_time_ms(obj_name: String):
	_load_cfg()
	if object_list.has(obj_name):
		return object_list[obj_name][2]
	return null

# returns ?Texture2D
func get_tex(tex_name: String):
	_load_cfg()
	if not tex_coords.has(tex_name):
		return null
	var tex_cfg = tex_coords.get(tex_name)
	var res_path = tex_cfg[0]
	var rect = tex_cfg[1]

	var base_tex = load(res_path)
	var tex = AtlasTexture.new()
	tex.atlas = base_tex
	tex.set_region(rect)
	return tex

# returns a new WantBubble Node, as configured in config does not have an ID set
# TODO: is it possible to make variadic functions in gdscript
func new_item(opts) -> WantBubble:
	_load_cfg()
	var tgt = ''
	if opts == null:
		opts = get_items()

	match typeof(opts):
		TYPE_STRING:
			tgt = opts
		TYPE_ARRAY:
			tgt = opts[randi_range(0, opts.size() - 1)]
		_:
			print('Passed invalid arg to new_item: ' + str(typeof(opts)))
			return null

	var wb_scene = preload('res://nodes/ui/WantBubble.tscn')
	var wb = wb_scene.instantiate()
	
	# unsafe, trusting input
	var parts = get_object_parts(tgt) as Array
	wb.item_tex = get_tex(tgt)
	wb.part_a_tex = get_tex(parts[0])
	wb.part_b_tex = get_tex(parts[1])

	wb.complete_time_ms = get_object_time_ms(tgt)
	wb.point_value = get_object_points(tgt)

	return wb

# get all defined items
func get_items() -> Array:
	_load_cfg()
	return object_list.keys()
