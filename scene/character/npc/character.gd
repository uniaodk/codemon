extends KinematicBody2D

signal chat_entered()
signal chat_exited()

func _on_chat_body_entered(_body: Node) -> void:
	emit_signal("chat_entered")

func _on_chat_body_exited(_body: Node) -> void:
	emit_signal("chat_exited")
