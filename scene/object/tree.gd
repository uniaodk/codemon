extends KinematicBody2D

export (int) var tree_index

func _ready() -> void:
	$sprite.texture = load("res://art/object/tree_0" + String(tree_index) + ".png")
