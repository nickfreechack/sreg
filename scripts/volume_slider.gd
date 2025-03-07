extends HSlider

@export var volume_level : float
var master_bus := AudioServer.get_bus_index("Master")

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	volume_level = value

func _on_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_mouse_exited() -> void:
	release_focus() # Replace with function body.

func _on_mute_button_toggled(_toggled_on: bool) -> void:
	if value != 0.00:
		volume_level = value
		value = 0.00
	else:
		value = volume_level
