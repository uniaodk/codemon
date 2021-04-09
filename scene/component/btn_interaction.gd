extends Control

signal pick_talk(reference)

func _ready() -> void:
	connect("pick_talk", game.get_last_child_root(), "_on_pick_talk_interaction")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_pick_talk"):
		emit_signal("pick_talk", $object.get_text())

func set_action(name: String, object: String) -> void:
	$action.text = name
	$object.text = object
