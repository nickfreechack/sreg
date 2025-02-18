extends Node3D

@export var curve: Curve3D
@export var line_radius = 0.1
@export var line_resolution = 3

@onready var broken_tether = $BrokenTetherMesh.get_surface_override_material(0)
@onready var short_tether = $ShortTetherMesh.get_surface_override_material(0)

var in_trial := false
var m1safe := false
var m2safe := false
var tethered_position = Vector3(0,0,0)
var ice := 0

var nw_safe = false
var sw_safe = false
var se_safe = false
var ne_safe = false

func _ready():
	tethered_position = Vector3(0,0,0)
	$Yippee.stream = preload("res://assets/audio/yippee-tbh.mp3")
	$Sploosh.stream = preload("res://assets/audio/ww_salvatore_sploosh.mp3")
	$Ohno.stream = preload("res://assets/audio/oh-no.mp3")
	$Yosh.stream = preload("res://assets/audio/yosh.mp3")
	nw_safe = false
	sw_safe = false
	se_safe = false
	ne_safe = false


func _process(delta):
	if !get_node("TrialCountdown").is_stopped(): 
		$Triggers/Label3D.text = str(int(get_node("TrialCountdown").get_time_left()) + 1)
	else:
		$Triggers/Label3D.text = str("")
	
	if tethered_position.distance_to($Player.get_position()) > 54:
		$Tether/CSGPolygon3D.material_override = broken_tether
		m1safe = true
	else:
		$Tether/CSGPolygon3D.material_override = short_tether
		m1safe = false
		
	
	if in_trial:
		curve.set_point_position(1, $Player.get_position())
		var circle = PackedVector2Array()
		for degree in line_resolution:
			var x = line_radius * sin(PI * 2 * degree / line_resolution)
			var y = line_radius * cos(PI * 2 * degree / line_resolution)
			var coords = Vector2(x,y)
			circle.append(coords)
		$Tether/CSGPolygon3D.polygon = circle
	


func begin_trial():
	ice = randi_range(1, 8)
	##print(ice)
	first_ice_visible()
	get_node("WaitForSecondIceTimer").start()
	match ice:
		1:
			first_ice_ne()
		2:
			first_ice_se()
		3:
			first_ice_sw()
		4:
			first_ice_nw()
		5:
			get_node("WaitForSecondIceNE").start()
		6:
			get_node("WaitForSecondIceSE").start()
		7:
			get_node("WaitForSecondIceSW").start()
		8:
			get_node("WaitForSecondIceNW").start()
	

func first_ice_ne():
	get_node("IceTimerFirst").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle1NE.get_position()
	curve.set_point_position(0, $Hazards/Icicle1NE.get_position())
	in_trial = true
	ne_safe = true

func first_ice_se():
	get_node("IceTimerFirst").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle1SE.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	se_safe = true

func first_ice_sw():
	get_node("IceTimerFirst").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle1SW.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	sw_safe = true
	
func first_ice_nw():
	get_node("IceTimerFirst").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle1NW.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	nw_safe = true

func second_ice_ne():
	get_node("IceTimerSecond").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle2NE.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	ne_safe = true

func second_ice_se():
	get_node("IceTimerSecond").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle2SE.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	se_safe = true

func second_ice_sw():
	get_node("IceTimerSecond").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle2SW.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	sw_safe = true
	
func second_ice_nw():
	get_node("IceTimerSecond").start()
	$Tether/CSGPolygon3D.visible = true
	tethered_position = $Hazards/Icicle2NW.get_position()
	curve.set_point_position(0, tethered_position)
	in_trial = true
	nw_safe = true

func second_trial():
	if m1safe:
		$Yippee.play()
		$Tether/CSGPolygon3D.visible = false
		first_ice_invisible()
		second_ice_invisible()
		$Triggers/MainPlatTrigger.visible = true
		get_node("SecondTrialTimer").start()
	else:
		$Player.lock_rotation = false
		$Sploosh.play()
		$Player.death_rattle()
		$Tether/CSGPolygon3D.visible = false
		get_node("DeathTimer").start()

func end_trial():
	if m2safe:
		$Yosh.play()
		$Triggers/StartTrigger.visible = true
		$Triggers/MainPlatTrigger.visible = false
		in_trial = false
		nw_safe = false
		sw_safe = false
		se_safe = false
		ne_safe = false
	else:
		$Player.lock_rotation = false
		$Sploosh.play()
		$Player.death_rattle()
		$Tether/CSGPolygon3D.visible = false
		get_node("DeathTimer").start()
		

func _on_start_trigger_body_entered(body : Node3D):
	if !in_trial:
		$Triggers/StartTrigger.visible = false
		in_trial = true
		get_node("TrialCountdown").start()
	

func _on_trial_countdown_timeout():
	begin_trial()

func first_ice_visible():
	$Hazards/Icicle1NE/IcicleCharge.visible = true
	$Hazards/Icicle1SE/IcicleCharge.visible = true
	$Hazards/Icicle1SW/IcicleCharge.visible = true
	$Hazards/Icicle1NW/IcicleCharge.visible = true
	
func first_ice_invisible():
	$Hazards/Icicle1NE/IcicleCharge.visible = false
	$Hazards/Icicle1SE/IcicleCharge.visible = false
	$Hazards/Icicle1SW/IcicleCharge.visible = false
	$Hazards/Icicle1NW/IcicleCharge.visible = false

func second_ice_visible():
	$Hazards/Icicle2NE/IcicleCharge.visible = true
	$Hazards/Icicle2SE/IcicleCharge.visible = true
	$Hazards/Icicle2SW/IcicleCharge.visible = true
	$Hazards/Icicle2NW/IcicleCharge.visible = true
	
func second_ice_invisible():
	$Hazards/Icicle2NE/IcicleCharge.visible = false
	$Hazards/Icicle2SE/IcicleCharge.visible = false
	$Hazards/Icicle2SW/IcicleCharge.visible = false
	$Hazards/Icicle2NW/IcicleCharge.visible = false



func _on_wait_for_second_ice_ne_timeout():
	second_ice_ne()

func _on_wait_for_second_ice_se_timeout():
	second_ice_se()

func _on_wait_for_second_ice_sw_timeout():
	second_ice_sw()

func _on_wait_for_second_ice_nw_timeout():
	second_ice_nw()

func _on_ice_timer_first_timeout():
	second_trial()


func _on_ice_timer_second_timeout():
	second_trial()

func _on_wait_for_second_ice_timer_timeout():
	second_ice_visible()

func _on_death_plane_body_entered(body):
	$Player.lock_rotation = false
	$Sploosh.play()
	$Player.death_rattle()
	$Tether/CSGPolygon3D.visible = false
	get_node("DeathTimer").start()


func _on_nw_zone_body_entered(body):
	if in_trial:
		if !nw_safe:
			$Ohno.play()
			$Stage/IceBridgeNW.queue_free()


func _on_sw_zone_body_entered(body):
	if in_trial:
		if !sw_safe:
			$Ohno.play()
			$Stage/IceBridgeSW.queue_free()


func _on_ne_zone_body_entered(body):
	if in_trial:
		if !ne_safe:
			$Ohno.play()
			$Stage/IceBridgeNE.queue_free()


func _on_se_zone_body_entered(body):
	if in_trial:
		if !se_safe:
			$Ohno.play()
			$Stage/IceBridgeSE.queue_free()


func _on_main_plat_trigger_body_entered(body):
	m2safe = true


func _on_main_plat_trigger_body_exited(body):
	m2safe = false


func _on_second_trial_timer_timeout():
	end_trial()
