extends Control

var interaction: int = 0

var seq: Dictionary = {0: {"text": "WHILE_TUT_1",
						   "position": Vector2(409, 82)},
					   1: {"text": "WHILE_TUT_2",
						   "position": Vector2(495, 107)},
					   2: {"text": "WHILE_TUT_3",
						   "position": Vector2(495, 107)}, 
					   3: {"text": "WHILE_TUT_4",
						   "position": Vector2(495, 107)}, 
					   4: {"text": "WHILE_TUT_5",
						   "position": Vector2(312, 163)},
					   5: {"text": "WHILE_TUT_6",
						   "position": Vector2(409, 82)},
					   6: {"text": "WHILE_TUT_7",
						   "position": Vector2(409, 82)},
					   7: {"text": "WHILE_TUT_8",
						   "position": Vector2(409, 82)},
					   8: {"text": "WHILE_TUT_9",
						   "position": Vector2(409, 82)}}

func _ready() -> void:
	translation()
	$red_square.visible = false
	$whilee.play_idle()
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
	$chalenge.text = tr("CHALLENGING") + " While";

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
			show_while_values()
		if [2,3].has(i):
			show_values_iteraction()
		if i == 4:
			$red_square.visible = false
			show_values_return()
		if i ==6:
			show_operator_logic()
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), true)
		yield($tip/tween, "tween_completed")
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_while = false
	queue_free()

func show_operator_logic() -> void:
	$function/vbox/line_1/s_3/balloon/value.text = "!="
	$function/vbox/line_1/s_3/animation.play("pop_up")

func show_while_values() -> void:
	$function/vbox/line_1/s_2/balloon/value.text = "2"
	$function/vbox/line_1/s_3/balloon/value.text = "<"
	$function/vbox/line_1/s_2/animation.play("pop_up")
	$function/vbox/line_1/s_3/animation.play("pop_up")

func show_values_iteraction() -> void:
	var red: Array = ["2", "4"]
	$function/vbox/line_2/s_6/balloon/value.text = red[interaction]
	$function/vbox/line_2/s_6/animation.play("pop_up")
	interaction = interaction + 1

func show_values_return() -> void:
	$function/vbox/line_5/s_1/balloon/value.text = "6"
	$function/vbox/line_5/s_1/animation.play("pop_up")
	$function/value_result.text = "6"
	$function/bg.color = Color("ccffcc")
