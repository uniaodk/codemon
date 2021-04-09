extends Control

var pos_btn_1: int 
var pos_btn_2: int 
var debug_count: int = 0

var first_debug: bool = true

var seq: Dictionary = {0: {"text": "O comando de controle IF possue um escopo de ação, sendo delimitado pela indentação do texto.",
						   "position": Vector2(302, 132)},
					   1: {"text": "Tendo a responsabilidade de executar ou não essa expressão.",
						   "position": Vector2(397, 167)},
					   2: {"text": "Dependendo do retorno da expressão booleana declarada ao seu lado.",
						   "position": Vector2(361, 129)},
					   3: {"text": "Para entender melhor, atribua o triângulo vermelho o tipo INT e o valor 2.",
						   "position": Vector2(97, 76)},
					   4: {"text": "E o hexágono azul o operador lógico LESS.",
						   "position": Vector2(94, 187)},
					   5: {"text": "Inicie a captura.",
						   "position": Vector2(645, 268)},
					   6: {"text": "Debug até o final",
						   "position": Vector2(488, 341)},
					   7: {"text": "Repare que expressão booleana retorna TRUE, pois 2 é menor que 3, consequentemente executa o escopo de ação.",
						   "position": Vector2(372, 108)},
					   8: {"text": "Vamos testar uma condição FALSE. Atribua o triângulo vermelho o tipo INT e o valor 2.",
						   "position": Vector2(97, 76)},
					   9: {"text": "E o hexágono azul o operador lógico BIGGER.",
						   "position": Vector2(94, 187)},
					  10: {"text": "Inicie a captura.",
						   "position": Vector2(645, 268)},
					  11: {"text": "Debug até o final",
						   "position": Vector2(488, 341)},
					  12: {"text": "Com a condição FALSE, o escopo de ação não é executado, afetando no valor do resultado.",
						   "position": Vector2(372, 108)}}

func _ready() -> void:
	$red_square.visible = false
	$iff.play_idle()
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
			$function/value_result.text = "False"
			$function/bg.color = Color("ffcccc")
			$tip/ok.emit_signal("pressed")
		debug_count = 3
	else: 
		$debuger.visible = false
		$function/value_result.text = "True"
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
	$btn_3.reset()
	$function/bg.color = Color("00ffffff")
	$function/value_result.text = ""
