extends Node3D

func play_song1():
	$AudioStreamPlayer.stream = preload("res://assets/audio/TheInterSlam.mp3")
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.volume_db = -10.0
# Called when the node enters the scene tree for the first time.

func stop_song():
	$AudioStreamPlayer.stop()
	

func pause_menu_volume():
	$AudioStreamPlayer.volume_db = -30.0
	

func resume_volume():
	$AudioStreamPlayer.volume_db = -10.0
	

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
