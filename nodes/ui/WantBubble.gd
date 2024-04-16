extends Node2D

class_name WantBubble

# fires if the want is not completed in time: (id: String)
signal timeout

# fires if the bubble is marked completed:
#     (id: String, points: int, remaining_ms: int)
signal completed

# some uniquely identifying id for this want to tie it to other systems
@export var id: String

# how long does the player have to complete this task
@export var complete_time_ms: int

# how many points is completing this want worth
@export var point_value: int

@export var display_timer: bool = true

# free the bubble after it times out or gets filled
@export var auto_free: bool = true

# what are we building
@export var item_tex: Texture2D
@export var part_a_tex: Texture2D
@export var part_b_tex: Texture2D

func set_complete_time_ms(time_ms: int) -> void:
	complete_time_ms = time_ms
	$CompletionTimer.run_time_sec = time_ms / 1000.0
	$CountdownTimer.run_time = time_ms / 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Frame/Item.texture = item_tex
	$Frame/PartA.texture = part_a_tex
	$Frame/PartB.texture = part_b_tex

func is_paused() -> bool:
	return $CompletionTimer.is_paused()

func pause() -> void:
	$CompletionTimer.pause()
	$CountdownTimer.pause()

func unpause() -> void:
	$CompletionTimer.start()
	$CountdownTimer.start()

# TODO
func _get_configuration_warning() -> String:
	return ""

func _on_completion_timer_timeout():
	$CompletionTimer.pause()
	$CountdownTimer.pause()
	timeout.emit(id)
	if auto_free:
		queue_free()

func fill() -> void:
	completed.emit(id, point_value, $CompletionTimer.remaining_time_ms())
	if auto_free:
		queue_free()
