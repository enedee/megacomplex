class_name Player extends CharacterBody3D

#input variables
const SPEED = 3.3
const JUMP_VELOCITY = 3.5
const SENSITIVITY = 0.003
const JUMP_ACCEL = 5.0
#headbobbing vars
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	#lock mouse to window center
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	#rotate player head (therefore camera) according to mouse input, lock rotation to 90°
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get  input direction, handle movement/deceleration
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if !is_on_floor():
			velocity.x = direction.x * JUMP_ACCEL
			velocity.z = direction.z * JUMP_ACCEL
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 11.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 11.0)

	#headbobbing effect
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
