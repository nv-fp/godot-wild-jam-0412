extends Node2D

var names = ["MasterVolume", "MusicVolume", "SfxVolume", "HudVolume"]

signal back

func _ready():
	var channels = AudioServer.bus_count
	
	for i in range(AudioServer.bus_count):
		var bus = AudioServer.get_bus_volume_db(i)
		var slider = get_node("SettingsItems").get_node(names[i]).get_node("HSlider")
		slider.value = bus
		slider.connect("value_changed", change_volume.bind(slider, i))

func change_volume(value: float, emitter, idx: int):
	AudioServer.set_bus_volume_db(idx, value)

func _back_event(viewport, event, shape_idx):
	if InputUtil.is_click(event):
		back.emit()

func _back_enter():
	$SettingsItems/BackButton.modulate = Color(1, .9, .9)

func _back_exit():
	$SettingsItems/BackButton.modulate = Color.WHITE
