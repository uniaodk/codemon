extends Control

var test_step: int = 0
var step: int = 76
var init_position: Vector2

func _ready() -> void:
	init_position = $needle.rect_position
	$tween.connect("tween_completed", self, "on_finish_move_needle")

func move_needle(to_step: int) -> void:
	var actual_position: Vector2 = $needle.rect_position
	var actual_step: int = (actual_position - init_position).x / step
	var step_to_do: int = (to_step - actual_step) * step
	var new_position: Vector2 = Vector2(actual_position.x + step_to_do, actual_position.y)
	$animation.play("roll")
	$tween.interpolate_property($needle, "rect_position:x",
		actual_position.x, new_position.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_left"):
#		print("left")
#		test_step = test_step - 1 if test_step > 0 else test_step
#		move_needle(test_step)
#	if event.is_action_pressed("ui_right"):
#		print("rigth")
#		test_step = test_step + 1 if test_step < 4 else test_step
#		move_needle(test_step)
#	if event.is_action_pressed("ui_accept"):
#		$needle/animation.play("stick")


func on_finish_move_needle(_object: Object, _key: Node) -> void:
	$animation.stop(true)
	
