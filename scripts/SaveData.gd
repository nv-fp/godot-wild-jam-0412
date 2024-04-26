extends Node

var save_path = 'user://helter_smelter.save'
var save_data

func init_save_file() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var json_data = JSON.stringify({})
	save_file.store_line(json_data)
	save_file.close()

func Load() -> void:
	if save_data != null:
		# already loaded save_data
		return

	save_data = {}

	if not FileAccess.file_exists(save_path):
		init_save_file()

	var save_file = FileAccess.open(save_path, FileAccess.READ)
	# just blindly trusting all the save file data is on one line
	var content_json_str = save_file.get_line()

	var content_json = JSON.new()
	var parse_result = content_json.parse(content_json_str)
	
	if not parse_result == OK:
		print('Failed to load save game data at ', save_path)
		save_file.close()
		return

	save_data = content_json.get_data() as Dictionary
	#for key in unparsed_data.keys():
		#var j = JSON.new()
		#if j.parse(unparsed_data[key]) != OK:
			#print('Failed to parse save data: ' + str(unparsed_data[key]))
		#else:
			#save_data[key] = j.get_data()
	save_file.close()

func Save() -> void:
	if save_data == null:
		print('Attempting to save empty lave data, saving default')
		init_save_file()
		return

	var json_str = JSON.stringify(save_data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		print('Failed to open ' + save_path)
		return 
	file.store_string(json_str)
	file.close()

func get_max_level():
	Load()
	return save_data.get('max_level', 0) as int

func get_high_score(level: int):
	Load()
	if not has_played(level):
		return null
	var key = 'level_' + str(level)
	return save_data.get(key)['score'] as int

func get_hammers(level: int):
	Load()
	if not has_played(level):
		return null
	var key = 'level_' + str(level)
	return save_data.get(key)['hammers'] as int

func record_max_level(level: int):
	Load()
	save_data['max_level'] = level
	Save()

func record_level(level: int, score: int, hammers: int):
	Load()
	var key = 'level_' + str(level)
	save_data[key] = {
		'score': score,
		'hammers': hammers,
	}
	Save()

func has_played(level: int) -> bool:
	Load()
	var key = 'level_' + str(level)
	return save_data.has(key)
