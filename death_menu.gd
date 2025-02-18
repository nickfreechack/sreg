extends Control



func _ready():
	$AnimationPlayer.play("RESET")
	$PanelContainer/VBoxContainer/RestartButton.grab_focus()

func resume():
	get_tree().paused = false
	BackgroundMusic.resume_volume()
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	BackgroundMusic.pause_menu_volume()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("blur")


func _on_restart_button_pressed():
	resume()
	get_tree().reload_current_scene()
	


func _on_main_menu_button_pressed():
	resume()
	BackgroundMusic.stop_song()
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	



func _process(delta):
	pass
	


func _on_death_timer_timeout():
	pause()
