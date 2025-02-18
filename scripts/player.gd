extends RigidBody3D

var mouse_sensitivity := 0.001
var cam_sensitivity := 0.08
var twist_input := 0.0
var pitch_input := 0.0

var player_velocity = 3000.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	var event
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	if input.length() > 1.0:
		input = input.normalized()
	
	apply_central_force(twist_pivot.basis * input * player_velocity * delta)
	
	
	if Input.is_action_pressed("right_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0
	
	right_stick_camera_used()

func right_stick_camera_used():
	var cam_input := Vector3.ZERO
	cam_input.x = Input.get_axis("cam_left", "cam_right")
	cam_input.y = Input.get_axis("cam_up", "cam_down")
	twist_input = - cam_input.x * cam_sensitivity
	pitch_input = - cam_input.y * cam_sensitivity

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
	
	

func death_rattle():
	apply_impulse(Vector3(randf_range(-20,20), 500.0, (randf_range(-20,20))), self.get_position())
	apply_torque(Vector3(randf_range(-200,200),randf_range(-200,200),randf_range(-200,200)))
