extends CheckButton

var master_bus := AudioServer.get_bus_index("Master")

func _on_toggled(_toggled_on: bool) -> void:
	if AudioServer.is_bus_mute(master_bus):
		AudioServer.set_bus_mute(master_bus, false)
	else:
		AudioServer.set_bus_mute(master_bus, true)


func _on_volume_slider_value_changed(value: float) -> void:
	if button_pressed == true && $"../VolumeSlider".value != 0:
		$"../VolumeSlider".volume_level = value
		$"../VolumeSlider".value = 0
		button_pressed = false
