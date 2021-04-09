extends Control

var pos_btn_1: int 
var pos_btn_2: int 
var debug_count: int = 0

var seq: Dictionary = {0: {"text": "O objetivo principal continua o mesmo. Atribuir tipos e valores as formas geométricas para resultar o valor esperado.",
						   "position": Vector2(429, 37)},
					   1: {"text": "Porém agora iremos utilizar os operadores aritméticos para auxiliar a chegar no valor esperado.",
						   "position": Vector2(3, 204)},
					   2: {"text": "Muito bem, vamos atribuir incialmente o tipo do triângulo vermelho como INT e valor 4",
						   "position": Vector2(109, 77)},
					   3: {"text": "E agora atribuir o operador aritmético MULTIPLY para o quadrado azul",
						   "position": Vector2(120, 190)},
					   4: {"text": "Clicar no botão Capturar para iniciar o debug da função.",
						   "position": Vector2(639, 265)},
					   5: {"text": "E apertar o botão Debug até finalizar a função.",
						   "position": Vector2(493, 343)},
					   6: {"text": "Muito bem! Que a força esteja com você.",
						   "position": Vector2(493, 343)}}

func _ready() -> void:
	$bigger.play_idle()
	$btn_1/btn.connect("focus_exited", self, "on_focus_exited_btn_1")
	$btn_1/label.connect("focus_exited", self, "on_focus_exited_btn_1_label")
	$btn_2/btn.connect("focus_exited", self, "on_focus_exited_btn_2")
	$btn_2/label.connect("focus_exited", self, "on_focus_exited_btn_2_label")
	config_button()
	init_tutorial()

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
	$btn_2.set_type("square")

func init_tutorial() -> void:
	for i in range(seq.size()):
		var vis_ok: bool = true
		if i == 2:
			move_child($btn_2, get_child_count() - 1)
			move_child($btn_1, get_child_count() - 2)
		if [2, 3, 4, 5].has(i):
			$tip/ok.visible = false
			vis_ok = false
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), vis_ok)
		yield($tip/tween, "tween_completed")
		$btn_1/btn.disabled = i != 2
		$btn_2/btn.disabled = i != 3
		$capture.disabled = i != 4
		$debuger.disabled = i != 5
		yield($tip/ok, "pressed")
	$tip.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	game.show_tutorial_analyze_2 = false
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
	if $btn_1.value == "4":
		$btn_1/label.disabled = true
		$tip/ok.visible = true

func on_focus_exited_btn_2() -> void:
	yield($btn_2, "codemon_selected")
	if $btn_2.codemon_selected == "multiply":
		move_child($btn_2, pos_btn_2)
		$btn_2/btn.disabled = true
		$tip/ok.visible = true


func _on_capture_pressed() -> void:
	$tip/ok.emit_signal("pressed")
	$debuger.visible = true
	$function/vbox/line_1/s_2/balloon/value.text = "4"
	$function/vbox/line_1/s_3/balloon/value.text = "*"
	$function/vbox/line_1/s_2/animation.play("pop_up")
	$function/vbox/line_1/s_3/animation.play("pop_up")


func _on_debuger_pressed() -> void:
	if debug_count == 0:
		$function/vbox/line_2/s_2/balloon/value.text = "8"
		$function/vbox/line_2/s_2/animation.play("pop_up")
		debug_count = 1
	elif debug_count == 1:
		$function/vbox/line_3/s_1/balloon/value.text = "True"
		$function/vbox/line_3/s_1/animation.play("pop_up")
		debug_count = 2
	else: 
		$debuger.visible = false
		$function/value_result.text = "True"
		$function/bg.color = Color("ccffcc")
		$tip/ok.emit_signal("pressed")
