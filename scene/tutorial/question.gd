extends Control

onready var success: Control = load("res://scene/interface/feedback_ok.tscn").instance()
onready var is_buff_capture: bool =  game.is_active_buff_capture
onready var	is_variable: bool = game.misson_variable
onready var is_operator: bool = game.mission_operator
onready var is_logic: bool = game.mission_logic
onready var is_buff_coin: bool = game.is_active_buff_coin


var seq: Dictionary = {0: {"text": "STAGE_1_TUT_1",
						   "position": Vector2(211, 23)},
					   1: {"text": "STAGE_1_TUT_2",
						   "position": Vector2(614, 86)},
					   2: {"text": "STAGE_1_TUT_3",
						   "position": Vector2(614, 291)},
					   3: {"text": "STAGE_1_TUT_4",
						   "position": Vector2(614, 336)},
					   4: {"text": "STAGE_1_TUT_5",
						   "position": Vector2(21, 126)},
					   5: {"text": "STAGE_1_TUT_6",
						   "position": Vector2(614, 243)},
					   6: {"text": "STAGE_1_TUT_7",
						   "position": Vector2(140, 127)},
					   7: {"text": "STAGE_1_TUT_8",
						   "position": Vector2(561, 42)},
					   8: {"text": "STAGE_1_TUT_9",
						   "position": Vector2(404, 104)},
					   9: {"text": "STAGE_1_TUT_10",
						   "position": Vector2(404, 198)},}

func _ready() -> void:
	translation();
	$chalenge/intt.play_idle()
	$options/a/awnser.text = "5"
	$options/b/awnser.text = "false"
	$options/c/awnser.text = "\"string\""
	$options/a.set_process(false)
	init_tutorial()

func translation() -> void:
	$title.text = tr("STAGE_1_TITLE");
	$question.text = tr("QUESTION_1");
	$capture/btn_name.text = tr("CAPTURE");
	$help/btn_name.text = tr("HELP");
	$flee/btn_name.text = tr("FLEE");
	$chalenge.text = tr("CHALLENGING") + " Int";

func init_tutorial() -> void:
	for i in range(seq.size()):
		var vis_ok: bool = true
		if [4, 5].has(i):
			$tip/ok.visible = false
			vis_ok = false
		if i == 7:
			success.codemon = game.CODEMON_INT
			success.is_tutorial = true
			config_sucess(true)
			add_child(success)
			move_child($tip, get_child_count() - 1)
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), vis_ok)
		yield($tip/tween, "tween_completed")
		$options/a.disabled = i != 4
		$capture.set_disabled(i != 5)
		yield($tip/ok, "pressed")
	config_default()
	$tip.visible = false
	game.show_tutorial_question = false

func config_sucess(active: bool) -> void:
	success.get_node("ok").disabled = active
	game.is_active_buff_capture = active
	game.misson_variable = active
	game.mission_operator = active
	game.mission_logic = active
	game.is_active_buff_coin = active

func config_default() -> void:
	success.get_node("ok").disabled = false
	game.is_active_buff_capture = is_buff_capture
	game.misson_variable = is_variable
	game.mission_operator = is_operator
	game.mission_logic = is_logic
	game.is_active_buff_coin = is_buff_coin

func _on_a_pressed() -> void:
	$options/a.disabled = true
	$tip/ok.visible = true


func _on_capture_pressed() -> void:
	$tip/ok.visible = true
	$capture.disabled = true
	$options/a/awnser.set("custom_colors/font_color", Color("0e9332"))
	$options/b/awnser.set("custom_colors/font_color", Color.red)
	$options/c/awnser.set("custom_colors/font_color", Color.red)
