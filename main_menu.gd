extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://level-sphene.tscn")
	BackgroundMusic.play_song1()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_kbm_button_toggled(toggled_on):
	pass # Replace with function body.
