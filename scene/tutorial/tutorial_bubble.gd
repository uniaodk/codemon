extends Control

var swap_count: int = 0
var ok_count: int = 0
var step: int = 105

onready var init_x: int = $bg/btn_swap.rect_position.x

var seq: Dictionary = {0: {"text": "BUBBLE_TUT_1",
						   "position": Vector2(251, 13)},
					   1: {"text": "BUBBLE_TUT_2",
						   "position": Vector2(114, 141)},
					   2: {"text": "BUBBLE_TUT_3",
						   "position": Vector2(114, 141)},
					   3: {"text": "BUBBLE_TUT_4",
						   "position": Vector2(111, 255)},
					   4: {"text": "BUBBLE_TUT_5",
						   "position": Vector2(111, 255)},
					   5: {"text": "BUBBLE_TUT_6",
						   "position": Vector2(215, 255)},
					   6: {"text": "BUBBLE_TUT_7",
						   "position": Vector2(215, 255)},
					   7: {"text": "BUBBLE_TUT_8",
						   "position": Vector2(268, 241)},
					   8: {"text": "BUBBLE_TUT_9",
						   "position": Vector2(111, 255)},
					   9: {"text": "BUBBLE_TUT_10",
						   "position": Vector2(350, 252)}}

func _ready() -> void:
	translation()
	$bg/bubble.play_idle()
	config_button()
	init_tutorial()

func translation() -> void:
	$bg/title.text = tr("BUBBLE_SORT");
	$bg/question.text = tr("STAGE_FINAL_DESC");
	$bg/chalenge.text = tr("CHALLENGING") + " " + tr("BUBBLE");
	$bg/flee/btn_name.text = tr("FLEE");
	$bg/help/btn_name.text = tr("HELP");

func config_button() -> void:
	$bg/flee.disabled = true
	$bg/help.disabled = true
	$bg/btn_swap/swap.connect("pressed", self, "on_swap_pressed")
	$bg/btn_swap/ok.connect("pressed", self, "on_ok_pressed")
	$bg/bubbles/b1/value.text = "3"
	$bg/bubbles/b2/value.text = "1"
	$bg/bubbles/b3/value.text = "2"
	$bg/btn_swap/ok.disabled = true
	$bg/btn_swap/swap.disabled = true

func init_tutorial() -> void:
	$bg/rope.move_needle(2)
	for i in range(seq.size()):
		var vis_ok: bool = true
		if [3, 4, 5, 6, 8].has(i):
			$bg/btn_swap.visible = true
			$tip/ok.visible = false
			vis_ok = false
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), vis_ok)
		yield($tip/tween, "tween_completed")
		$bg/btn_swap/swap.disabled = ![3, 5].has(i)
		$bg/btn_swap/ok.disabled = ![4, 6, 8].has(i)
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_bubble = false
	queue_free()


func move_btn_swap(to_step: int) -> void:
	var actual_x: int = $bg/btn_swap.rect_position.x
	var actual_step: int = (actual_x - init_x) / step
	var step_to_do: int = (to_step - actual_step) * step
	$bg/btn_swap.rect_position.x = actual_x + step_to_do

func on_swap_pressed() -> void:
	if swap_count == 0:
		$bg/bubbles/b1/animation.play("disapear")
		$bg/bubbles/b2/animation.play("disapear")
		$bg/bubbles/b1/value.text = "1"
		$bg/bubbles/b2/value.text = "3"
		$bg/bubbles/b1/animation.play("appear")
		$bg/bubbles/b2/animation.play("appear")
	if swap_count == 1:
		$bg/bubbles/b2/animation.play("disapear")
		$bg/bubbles/b3/animation.play("disapear")
		$bg/bubbles/b2/value.text = "2"
		$bg/bubbles/b3/value.text = "3"
		$bg/bubbles/b2/animation.play("appear")
		$bg/bubbles/b3/animation.play("appear")
	$tip/ok.visible = true
	$bg/btn_swap/swap.disabled = true
	swap_count = swap_count + 1
	
func on_ok_pressed() -> void:
	if ok_count == 0:
		move_btn_swap(1)
	if ok_count == 1:
		$bg/rope/needle/animation.play("stick")
		$bg/btn_swap.visible = false
		$bg/bubbles/b3/animation.play("pop")
		yield($bg/bubbles/b3/animation, "animation_finished")
		move_btn_swap(0)
		$bg/rope.move_needle(1)
		$bg/btn_swap/ok.disabled = true
	if ok_count == 2:
		$bg/rope/needle/animation.play("stick")
		$bg/btn_swap.visible = false
		$bg/bubbles/b2/animation.play("pop")
		yield($bg/bubbles/b2/animation, "animation_finished")
		$bg/rope.move_needle(0)
		yield($bg/rope/tween, "tween_completed")
		$bg/rope/needle/animation.play("stick")
		$bg/bubbles/b1/animation.play("pop")
		yield($bg/bubbles/b1/animation, "animation_finished")
		$bg/bubbles/b1/value.set("custom_colors/font_color", Color("0e9332"))
		$bg/bubbles/b2/value.set("custom_colors/font_color", Color("0e9332"))
		$bg/bubbles/b3/value.set("custom_colors/font_color", Color("0e9332"))
	$tip/ok.visible = true
	$bg/btn_swap/ok.disabled = true
	ok_count = ok_count + 1
	
