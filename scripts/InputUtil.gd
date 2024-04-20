extends Node

func is_click(event: InputEvent) -> bool:
	return event.is_class('InputEventMouseButton') and event.pressed

func ui_accept() -> bool:
	return (
		Input.is_action_just_pressed('interaction') or
		Input.is_action_just_pressed('ui_accept')
	)
