extends Node

func is_click(event: InputEvent) -> bool:
	return event.is_class('InputEventMouseButton') and event.pressed
