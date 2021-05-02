extends Control

onready var fail: Control = load("res://scene/interface/feedback_fail.tscn").instance()
onready var help: Resource = load("res://scene/interface/help.tscn")

onready var init_x: int = $bg/btn_swap.rect_position.x

var index: int = 0
var interaction: int = 0

var size: int = 5
var values: Array
var correct_values: Array
var step: int = 105

var sort_step: int = 1
var is_simulation: bool = false

func _ready() -> void:
	init_translation();
	$bg.connect("end_dialogue", self, "_on_end_dialogue")
	$bg/bubble.play_idle()
	update_values()
	init_connections()
	routine_bubble()

func init_translation() -> void:
	$bg/title.text = tr("BUBBLE_SORT");
	$bg/question.text = tr("STAGE_FINAL_DESC");
	$bg/chalenge.text = tr("CHALLENGING") + " " + tr("BUBBLE");
	$bg/flee/btn_name.text = tr("FLEE");
	$bg/help/btn_name.text = tr("HELP");

func update_values() -> void:
	values.clear()
	for i in range(size):
		if sort_step == 1:
			randomize()
			values.append(String(randi() % 899 + 100))
			get_node("bg/bubbles/b" + String(i + 1)).update_codemon("intt")
		else:
			values.append(rand_string())
			get_node("bg/bubbles/b" + String(i + 1)).update_codemon("String")
		get_node("bg/bubbles/b" + String(i + 1) + "/value").set("custom_colors/font_color", Color.black)
		get_node("bg/bubbles/b" + String(i + 1)).get_node("value").text = values[i]
	update_value_array()
	
func init_connections() -> void:
	$bg/btn_swap/swap.connect("pressed", self, "on_swap_pressed")
	$bg/btn_swap/ok.connect("pressed", self, "on_ok_pressed")
	$bg/rope/needle/animation.connect("animation_finished", self, "on_animation_finished")
	$bg/bubbles/b1/animation.connect("animation_finished", self, "on_animation_finished")
	$bg/bubbles/b2/animation.connect("animation_finished", self, "on_animation_finished")
	$bg/bubbles/b3/animation.connect("animation_finished", self, "on_animation_finished")
	$bg/bubbles/b4/animation.connect("animation_finished", self, "on_animation_finished")
	$bg/bubbles/b5/animation.connect("animation_finished", self, "on_animation_finished")
	
func draw_for1() -> void:
	if interaction != 4:
		$bg/function/line_3/i/balloon/value.text = String(interaction)
		$bg/function/line_3/size/balloon/value.text = String(size)
		$bg/function/line_3/i/animation.play("pop_up")
		$bg/function/line_3/size/animation.play("pop_up")
	
func draw_for2() -> void:
	$bg/function/line_4/j/balloon/value.text = String(index)
	$bg/function/line_4/size/balloon/value.text = String(size)
	$bg/function/line_4/i/balloon/value.text = String(interaction)
	$bg/function/line_6/arr1/balloon/value.text = String(values[index])
	$bg/function/line_6/j1/balloon/value.text = String(index)
	$bg/function/line_6/arr2/balloon/value.text = String(values[index + 1])
	$bg/function/line_6/j2/balloon/value.text = String(index)
	$bg/function/line_4/j/animation.play("pop_up")
	$bg/function/line_4/size/animation.play("pop_up")
	$bg/function/line_4/i/animation.play("pop_up")
	$bg/function/line_6/arr1/animation.play("pop_up")
	$bg/function/line_6/j1/animation.play("pop_up")
	$bg/function/line_6/arr2/animation.play("pop_up")
	$bg/function/line_6/j2/animation.play("pop_up")

func routine_bubble() -> void:
	$bg/btn_swap.visible = true
	$bg/rope.move_needle(size - 1)
	correct_values = values.duplicate(true)
	for i in range (size):
		interaction = i
		draw_for1()
		for j in range (size - 1 - i):
			index = j
			draw_for2()
			move_btn_swap(j)
			yield($bg/btn_swap/ok, "pressed")
		$bg/rope/needle/animation.play("stick")
		$bg/btn_swap.visible = false
		if i != 4:
			yield($bg/rope/tween, "tween_completed")
			$bg/btn_swap.visible = true
	result()

func result() -> void:
	if validate_sort() and sort_step == 1:
		yield(get_tree().create_timer(2.0), "timeout")
		sort_step = sort_step + 1
		game.run_dialogue("bubble", $bg)
		yield($bg, "end_dialogue")
		print('passou')
		update_values()
		routine_bubble()
	elif validate_sort() and sort_step ==2:
		yield(get_tree().create_timer(2.0), "timeout")
		game.bubble_quest = 2
		$bg/help.disabled = true
		$bg/flee.disabled = true
		game.run_dialogue("bubble", $bg)
		persistence.save_progress()
	else:
		yield(get_tree().create_timer(2.0), "timeout")
		game.energy = game.energy - 1
		fail.is_simulation = true
		fail.get_node("msg").text = "A desordem continua\nDúvidas procure o Dr Compilador"
		fail.codemon = "bubble_sort"
		add_child(fail)
		


func validate_sort() -> bool:
	correct_values.sort()
	print("sorted " + String(correct_values))
	var temp: bool = true
	for i in range (values.size()):
		var color: Color = Color("0e9332")
		if correct_values[i] != values[i]:
			temp = false
			color = Color.red
		get_node("bg/bubbles/b" + String(i + 1) + "/value").set("custom_colors/font_color", color)
	return temp

func on_ok_pressed() -> void:
	print("values " + String(values))

func on_swap_pressed() -> void:
	$bg/btn_swap/animation.play("swap")
	$bg/bubbles.get_child(index).get_node("animation").play("disapear")
	$bg/bubbles.get_child(index + 1).get_node("animation").play("disapear")
	
	swap_values()
	$bg/bubbles.get_child(index).get_node("value").text = String(values[index])
	$bg/bubbles.get_child(index + 1).get_node("value").text = String(values[index +1])
	
	$bg/bubbles.get_child(index).get_node("animation").play("appear")
	$bg/bubbles.get_child(index + 1).get_node("animation").play("appear")

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "stick":
		get_node("bg/bubbles/b" + String(size - interaction) + "/animation").play("pop")
	if anim_name == "pop" and interaction != 4:
		$bg/rope.move_needle((size - 2) - interaction)

func swap_values() -> void:
	var temp: String = values[index]
	values[index] = values[index + 1]
	values[index + 1] = temp

func move_btn_swap(to_step: int) -> void:
	var actual_x: int = $bg/btn_swap.rect_position.x
	var actual_step: int = (actual_x - init_x) / step
	var step_to_do: int = (to_step - actual_step) * step
	$bg/btn_swap.rect_position.x = actual_x + step_to_do
	
func rand_string() -> String:
	var temp: String = ""
	for i in range(3):
		randomize()
		temp = temp + "%c" % [randi() % 25 + 97]
	return temp

	
func update_value_array() -> void:
	var temp: String = ""
	for v in values:
		if sort_step == 1:
			temp = temp + v + ","
		else:
			temp = temp + "\"" + v + "\","
	temp = temp.left(temp.length() -1)
	$bg/function/line_1/array_value.text = temp

func _on_end_dialogue(reference: String) -> void:
	if game.bubble_quest == 2:
		$bg/tween.interpolate_property($bg, "modulate:a8", 255, 0, 3
			,Tween.TRANS_LINEAR, Tween.EASE_IN)
		$bg/tween.start()

func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	if !is_simulation:
		game.is_finished_game = true
		get_parent().get_parent().end_game()
	get_tree().paused = false
	queue_free()


func _on_help_pressed() -> void:
	var help_instance: CanvasLayer = help.instance()
	help_instance.set_image("bubble_sort")
	$bg.add_child(help_instance)

func _on_flee_pressed() -> void:
	get_tree().paused = false
	queue_free()
