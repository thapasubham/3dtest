extends Node3D

var enemies: PackedScene = load("res://scenes/cube.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func spawn():
	if Global.count < 12 :
		var enemy = enemies.instantiate()
		enemy.get_children(true)
		add_child(enemy)
	pass

func _on_timer_timeout() -> void:
	spawn()
	Global.count+=1
	pass # Replace with function body.
