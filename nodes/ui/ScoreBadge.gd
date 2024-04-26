extends Node2D

func setup(level: int) -> void:
	print('ScoreBadge.setup(' + str(level) + ')')
	if SaveData.has_played(level):
		load_data(level)
	else:
		visible = false

func load_data(level: int) -> void:
	var score = SaveData.get_high_score(level)
	var hammers = SaveData.get_hammers(level)

	for idx in range(1, hammers + 1):
		var n = $Hammers.get_node('Hammer' + str(idx))
		n.texture = preload('res://art/level-summary/full-hammer.png')

	$Score.text = str(score)
