extends Node2D

# fires if the want is not completed in time: (id: String)
signal timeout

# fires if the bubble is marked completed: (id: String, points: int)
signal completed

# some uniquely identifying id for this want to tie it to other systems
@export var id: String

# how long does the player have to complete this task
@export var complete_time_ms: int

# how many points is completing this want worth
@export var point_value: int

# what are we building
@export var item_tex: Texture2D
@export var part_a_tex: Texture2D
@export var part_b_tex: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Frame/Item.texture = item_tex
	$Frame/PartA.texture = part_a_tex
	$Frame/PartB.texture = part_b_tex
	$CompletionTimer.run_time_sec = complete_time_ms / 1000.0

func pause() -> void:
	$CompletionTimer.pause()

func unpause() -> void:
	$CompletionTimer.start()

# TODO
func _get_configuration_warning() -> String:
	return ""

func _on_completion_timer_timeout():
	timeout.emit(id)
	queue_free()

func fill() -> void:
	completed.emit(id, point_value)
	queue_free()
