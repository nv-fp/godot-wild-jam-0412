extends Label

var cur_score = 0

func update_score(val: int) -> void:
	cur_score += val
	
	var s = abs(cur_score)
	var d1 = s / 1000
	var d2 = (s - (d1 * 1000)) / 100 as int
	var d3 = (s - (d1 * 1000) - (d2 * 100)) / 10 as int
	var d4 = (s - (d1 * 1000) - (d2 * 100) - (d3 * 10)) as int
	
	$Digit1.text = str(d1)
	$Digit2.text = str(d2)
	$Digit3.text = str(d3)
	$Digit4.text = str(d4)
	$Negative.visible = cur_score < 0
