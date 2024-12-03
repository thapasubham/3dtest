extends Node3D

@onready var player = $player


var PlayerPosition
var enemyPosition
# Called when the node enters the scene tree for the first time.
const RAY_LENGTH = 1000.0
func _ready() -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit") :
		get_tree().quit()
	
	

func _physics_process(delta: float) -> void:
	get_tree().call_group('enemy', 'update_target_location', player.global_transform.origin)

# Replace with function body.
