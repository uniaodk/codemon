extends Control

var pos_btn_1: int 
var pos_btn_2: int 
var debug_count: int = 0

var first_debug: bool = true

var seq: Dictionary = {0: {"text": "ELSE_TUT_1",
						   "position": Vector2(481, 104)},
					   1: {"text": "ELSE_TUT_2",
						   "position": Vector2(362, 85)},
					   2: {"text": "ELSE_TUT_3",
						   "position": Vector2(362, 85)},
					   3: {"text": "ELSE_TUT_4",
						   "position": Vector2(441, 110)},
					   4: {"text": "ELSE_TUT_5",
						   "position": Vector2(442, 203)},
					   5: {"text": "ELSE_TUT_6",
						   "position": Vector2(362, 85)},
					   6: {"text": "ELSE_TUT_7",
						   "position": Vector2(441, 110)},
					   7: {"text": "ELSE_TUT_8",
						   "position": Vector2(442, 203)}}

func _ready() -> void:
	translation()
	$elsee.play_idle()
	$btn_1/btn.connect("focus_exited", self, "on_focus_exited_btn_1")
	$btn_1/label.connect("focus_exited", self, "on_focus_exited_btn_1_label")
	$btn_2/btn.connect("focus_exited", self, "on_focus_exited_btn_2")
	$btn_2/label.connect("focus_exited", self, "on_focus_exited_btn_2_label")
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
	$chalenge.text = tr("CHALLENGING") + " Else";

func config_button() -> void:
	pos_btn_1 = $btn_1.get_position_in_parent()
	pos_btn_2 = $btn_2.get_position_in_parent()
	$capture.disabled = true
	$flee.disabled = true
	$help.disabled = true
	$debuger.disabled = true
	$btn_1/btn.disabled = true
	$btn_2/btn.disabled = true
	$btn_1.set_type("triangle")
	$btn_2.set_type("circle")

func init_tutorial() -> void:
	for i in range(seq.size()):
		if i == 3:
			show_values_shape_if()
		if i == 6:
			reset_shapes()
			show_values_shape_else()
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), true)
		yield($tip/tween, "tween_completed")
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_else = false
	queue_free()

func reset_shapes() -> void:
	$function/vbox/line_1/s_2/balloon.visible = false
	$function/vbox/line_1/s_3/balloon.visible = false
	
	$function/vbox/line_2/s_4/balloon.visible = false

	$function/vbox/line_5/s_1/balloon.visible = false

func show_values_shape_if() -> void:
	$function/vbox/line_1/s_2/balloon/value.text = "2"
	$function/vbox/line_1/s_3/balloon/value.text = "<"
	$function/vbox/line_1/s_2/animation.play("pop_up")
	$function/vbox/line_1/s_3/animation.play("pop_up")
	
	$function/vbox/line_2/s_4/balloon/value.text = "2"
	$function/vbox/line_2/s_4/animation.play("pop_up")

	$function/vbox/line_5/s_1/balloon/value.text = "4"
	$function/vbox/line_5/s_1/animation.play("pop_up")
	
	$function/value_result.text = "4"
	$function/bg.color = Color("ccffcc")

func show_values_shape_else() -> void:
	$function/vbox/line_1/s_2/balloon/value.text = "4"
	$function/vbox/line_1/s_3/balloon/value.text = "<"
	$function/vbox/line_1/s_2/animation.play("pop_up")
	$function/vbox/line_1/s_3/animation.play("pop_up")
	
	$function/vbox/line_4/s_5/balloon/value.text = "4"
	$function/vbox/line_4/s_5/animation.play("pop_up")

	$function/vbox/line_5/s_1/balloon/value.text = "8"
	$function/vbox/line_5/s_1/animation.play("pop_up")
	
	$function/value_result.text = "8"
	$function/bg.color = Color("ffcccc")
