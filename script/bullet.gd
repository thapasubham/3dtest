extends Area3D

signal health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	
	body.position = Vector3(2,3,4)
	body.queue_free()
	Global.count -=1
	queue_free()
	health.emit()
	pass # Replace with function body.
