extends CharacterBody3D

@onready var head =$head
@onready var camera = $head/Camera3D
@onready var gun = $head/Camera3D/weapon/gun
var speed 
const SENS =0.005
const WALKSPEED = 10
const CROUCHSPEED = 5
const  SPRINT = 15
const JUMP_VELOCITY = 5
const GRAVITY = 9
const AMP =  0.03
const FREQ = 2.0
var t_bob =0
var fov = 70.0
var bullet: PackedScene = load("res://scenes/bullet.tscn")
var fire = true
var fov_change =1.5
var weapon 
signal ray()

func _ready():
	weapon = Weapon.new()
	position = Vector3(0,0,2)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func  _unhandled_input(event: InputEvent):
	
	if Input.is_action_just_pressed("quit") :
		get_tree().quit()
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x*SENS)
		camera.rotate_x(-event.relative.y*SENS) 
		camera.rotation.x= clamp(camera.rotation.x, -PI/2, PI/2)
		
	
	if Input.is_action_pressed("shoot") && fire:
		shoot()
		fire = false
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY* delta

	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT
	elif Input.is_action_pressed("crouch"):
		speed = CROUCHSPEED
	else:
		speed = WALKSPEED

		
	# Get the input direction and handle the movement/deceleration..
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta *5)
			velocity.z = lerp(velocity.z, direction.z * speed, delta*5)
			
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta *3)
			velocity.z = lerp(velocity.z, direction.z * speed, delta*3)
			
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 0.5)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 0.5)

	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and validJump() :
		
		velocity = Vector3(velocity.x, JUMP_VELOCITY, velocity.z)
	
	#camera shake and fov 
	t_bob += delta* velocity.length() *float(is_on_floor())
	camera.position = _head_bob(t_bob)
	
	
	move_and_slide()

func validJump():
	return is_on_floor()

func shoot():
	var space_state= camera.get_world_3d().direct_space_state
	var screen_cursor = get_viewport().size/2
	var origin = camera.project_ray_origin(screen_cursor)
	var end = origin+ camera.project_ray_normal(screen_cursor)*1000
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	print(result)
	if result:
		test_raycast(result.get("position"))
	
func test_raycast(position: Vector3):
	var bull = bullet.instantiate()
	get_tree().root.add_child(bull)
	bull.global_position = position
	await get_tree().create_timer(3).timeout
	if bull!= null:
		bull.queue_free()

func _head_bob(time)->Vector3:
	var pos = Vector3.ZERO
	pos.y = cos(time*FREQ)*AMP
	pos.x = sin(time*FREQ*0.5)*AMP
	return pos


func _on_timer_timeout() -> void:
	fire = true
	pass # Replace with function body.
