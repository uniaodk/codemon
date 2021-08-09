extends Control

var pos_btn_1: int 
var pos_btn_2: int 
var debug_count: int = 0

var first_debug: bool = true

var seq: Dictionary = {0: {"text": "IF_TUT_1",
						   "position": Vector2(302, 132)},
					   1: {"text": "IF_TUT_2",
						   "position": Vector2(397, 167)},
					   2: {"text": "IF_TUT_3",
						   "position": Vector2(361, 129)},
					   3: {"text": "IF_TUT_4",
						   "position": Vector2(97, 76)},
					   4: {"text": "IF_TUT_5",
						   "position": Vector2(94, 187)},
					   5: {"text": "IF_TUT_6",
						   "position": Vector2(645, 268)},
					   6: {"text": "IF_TUT_7",
						   "position": Vector2(488, 341)},
					   7: {"text": "IF_TUT_8",
						   "position": Vector2(372, 108)},
					   8: {"text": "IF_TUT_9",
						   "position": Vector2(97, 76)},
					   9: {"text": "IF_TUT_10",
						   "position": Vector2(94, 187)},
					  10: {"text": "IF_TUT_11",
						   "position": Vector2(645, 268)},
					  11: {"text": "IF_TUT_12",
						   "position": Vector2(488, 341)},
					  12: {"text": "IF_TUT_13",
						   "position": Vector2(372, 108)}}

func _ready() -> void:
	translation()
	$red_square.visible = false
	$iff.play_idle()
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
	$chalenge.text = tr("CHALLENGING") + " If";

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
		var vis_ok: bool = true
		$red_square.visible = i == 1
		if i == 8:
			reset_debug_action()
		if [3, 8].has(i):
			move_child($btn_2, get_child_count() - 1)
			move_child($btn_1, get_child_count() - 2)
		if [3,4,5,6,8,9,10,11].has(i):
			$tip/ok.visible = false
			vis_ok = false
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), vis_ok)
		yield($tip/tween, "tween_completed")
		$btn_1/btn.disabled = ![3, 8].has(i)
		$btn_2/btn.disabled = ![4, 9].has(i)
		$capture.disabled = ![5, 10].has(i)
		$debuger.disabled = ![6, 11].has(i)
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_if = false
	queue_free()

func on_focus_exited_btn_1() -> void:
	yield($btn_1, "codemon_selected")
	$btn_1/label.disabled = true
	$btn_1/label/text.release_focus()
	if $btn_1.codemon_selected == "int":
		move_child($btn_1, pos_btn_1)
		$btn_1/btn.disabled = true
		$btn_1/label.disabled = false

func on_focus_exited_btn_1_label() -> void:
	yield($btn_1, "set_text")
	if $btn_1.value == "2":
		$btn_1/label.disabled = true
		$tip/ok.visible = true

func on_focus_exited_btn_2() -> void:
	yield($btn_2, "codemon_selected")
	if ((first_debug and $btn_2.codemon_selected == "less")
	or (!first_debug and $btn_2.codemon_selected == "bigger")):
		move_child($btn_2, pos_btn_2)
		$btn_2/btn.disabled = true
		$tip/ok.visible = true


func _on_capture_pressed() -> void:
	$tip/ok.emit_signal("pressed")
	$debuger.visible = true


func _on_debuger_pressed() -> void:
	if debug_count == 0:
		$function/vbox/line_2/s_3/balloon/value.text = "<" if first_debug else ">"
		$function/vbox/line_2/s_3/animation.play("pop_up")
		$function/vbox/line_2/s_2/balloon/value.text = "2"
		$function/vbox/line_2/s_2/animation.play("pop_up")
		debug_count = 1
	elif debug_count == 1:
		if first_debug:
			$function/vbox/line_3/s_2/balloon/value.text = "2"
			$function/vbox/line_3/s_2/animation.play("pop_up")
		else: 
			$function/vbox/line_4/s_1/balloon/value.text = "2"
			$function/vbox/line_4/s_1/animation.play("pop_up")
		debug_count = 2
	elif debug_count == 2:
		if first_debug:
			$function/vbox/line_4/s_1/balloon/value.text = "4"
			$function/vbox/line_4/s_1/animation.play("pop_up")
		else:
			$debuger.visible = false
			$function/value_result.text = "2"
			$function/bg.color = Color("ffcccc")
			$tip/ok.emit_signal("pressed")
		debug_count = 3
	else: 
		$debuger.visible = false
		$function/value_result.text = "4"
		$function/bg.color = Color("ccffcc")
		$tip/ok.emit_signal("pressed")
		debug_count = 0
		first_debug = false


func reset_debug_action() -> void:
	$function/vbox/line_2/s_2/balloon.visible = false
	$function/vbox/line_2/s_3/balloon.visible = false
	$function/vbox/line_3/s_2/balloon.visible = false
	$function/vbox/line_4/s_1/balloon.visible = false
	$btn_1.reset()
	$btn_2.reset()
	$function/bg.color = Color("00ffffff")
	$function/value_result.text = ""
