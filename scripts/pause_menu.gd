extends Control

var dead = false

func _ready():
	$PanelContainer/VBoxContainer/Label.text = "Paused"
	$PanelContainer/VBoxContainer/ResumeButton.visible = true
	$AnimationPlayer.play("RESET")
	$PanelContainer/VBoxContainer/ResumeButton.grab_focus()

func resume():
	get_tree().paused = false
	BackgroundMusic.resume_volume()
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	BackgroundMusic.pause_menu_volume()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("blur")

func _on_escape_pressed():
	if !dead:
		if Input.is_action_just_pressed("escape") and !get_tree().paused:
			pause()
		elif Input.is_action_just_pressed("escape") and get_tree().paused:
			resume()


func _on_resume_button_pressed():
	resume()

func _on_restart_button_pressed():
	resume()
	get_tree().reload_current_scene()
	


func _on_main_menu_button_pressed():
	resume()
	BackgroundMusic.stop_song()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	

func _process(delta):
	_on_escape_pressed()
	


func _on_death_timer_timeout():
	dead = true
	pause()
	$PanelContainer/VBoxContainer/Label.text = "You died!"
	$PanelContainer/VBoxContainer/ResumeButton.visible = false
	$PanelContainer/VBoxContainer/RestartButton.grab_focus()
	
