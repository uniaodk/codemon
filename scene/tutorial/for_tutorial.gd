extends Control

var interaction: int = 0

var seq: Dictionary = {0: {"text": "FOR_TUT_1",
						   "position": Vector2(522, 87)},
					   1: {"text": "FOR_TUT_2",
						   "position": Vector2(432, 87)},
					   2: {"text": "FOR_TUT_3",
						   "position": Vector2(414, 110)}, 
					   3: {"text": "FOR_TUT_4",
						   "position": Vector2(414, 110)},
					   4: {"text": "FOR_TUT_5",
						   "position": Vector2(414, 110)},
					   5: {"text": "FOR_TUT_6",
						   "position": Vector2(359, 139)}}

func _ready() -> void:
	translation()
	$red_square.visible = false
	$forr.play_idle()
	config_button()
	init_tutorial()

func translation() -> void:
	$title.text = tr("STAGE_2_TITLE");
	$question.text = tr("STAGE_2_DESC");
	$function/title.text = tr("FUNCTION");
	$function/waited.text = tr("EXPECTED");
	$function/result.text = tr("RESULT");
	$hint/title.text = tr("REMINDER");
	$hint/variable.text = tr("VARIABLES");
	$hint/arithmetic.text = tr("ARITHMETIC_OP2");
	$hint/logic.text = tr("LOGIC_OP2");
	$capture/btn_name.text = tr("CAPTURE");
	$flee/btn_name.text = tr("FLEE");
	$help/btn_name.text = tr("HELP");
	$debuger/btn_name.text = tr("DEBUG");
	$chalenge.text = tr("CHALLENGING") + " For";

func config_button() -> void:
	$capture.disabled = true
	$flee.disabled = true
	$help.disabled = true
	$debuger.disabled = true
	$btn_1/btn.disabled = true
	$btn_2/btn.disabled = true
	$btn_1.set_type("triangle")
	$btn_2.set_type("triangle")

func init_tutorial() -> void:
	for i in range(seq.size()):
		if i == 1:
			$red_square.visible = true
			show_for_values()
		if [2,3,4].has(i):
			show_values_iteraction()
		if i == 5:
			$red_square.visible = false
			show_values_return()
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), true)
		yield($tip/tween, "tween_completed")
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_for = false
	queue_free()

func show_for_values() -> void:
	$function/vbox/line_1/s_2/balloon/value.text = "0"
	$function/vbox/line_1/s_3/balloon/value.text = "3"
	$function/vbox/line_1/s_2/animation.play("pop_up")
	$function/vbox/line_1/s_3/animation.play("pop_up")

func show_values_iteraction() -> void:
	var red: Array = ["1", "3", "6"]
	var white: Array = ["0", "1", "2"]
	$function/vbox/line_2/s_5/balloon/value.text = white[interaction]
	$function/vbox/line_2/s_5/animation.play("pop_up")
	$function/vbox/line_2/s_6/balloon/value.text = red[interaction]
	$function/vbox/line_2/s_6/animation.play("pop_up")
	interaction = interaction + 1

func show_values_return() -> void:
	$function/vbox/line_5/s_1/balloon/value.text = "10"
	$function/vbox/line_5/s_1/animation.play("pop_up")
	$function/value_result.text = "10"
	$function/bg.color = Color("ccffcc")
