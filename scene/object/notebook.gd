extends KinematicBody2D

signal pickup_entered()
signal pickup_exited()

func _on_pickup_body_entered(_body: Node) -> void:
	emit_signal("pickup_entered")
	
func _on_pickup_body_exited(_body: Node) -> void:
	emit_signal("pickup_exited")
