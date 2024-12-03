extends CharacterBody3D


const SPEED = 2
const JUMP_VELOCITY = 4.5
@onready var nav = $NavigationAgent3D
var HEALTH = 50
func _ready() -> void:
	var rgn = RandomNumberGenerator.new()
	position = Vector3(randf_range(-10.0, 10.0), 0, randf_range(-10.0, 10.0))
	
	pass
func _physics_process(delta: float) -> void:
	
	var currentLocation = global_transform.origin
	var next_location = nav.get_next_path_position()
	var desired_velocity = (next_location - currentLocation).normalized()*SPEED
	velocity = velocity.move_toward(desired_velocity, SPEED)
	move_and_slide()


func update_target_location(target_location):
	var distance  = global_transform.origin.distance_to(target_location)
	if distance<10:
		nav.target_position = target_location
