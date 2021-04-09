extends Control

var interaction: int = 0

var seq: Dictionary = {0: {"text": "O comando de controle FOR pode executar ou não seu escopo várias vezes, dependendo da quantidade do range atribuído.",
						   "position": Vector2(522, 87)},
					   1: {"text": "Digamos que o range foi atribuido o valor 3. Significa dizer que o escopo marcado com a caixa vermelha será executada 3 vezes.",
						   "position": Vector2(432, 87)},
					   2: {"text": "Vamos iniciar a 1ª iteração. Repare que o triângulo branco está com valor 0. Isso porque ele fica responsável em fazer a contagem do range.",
						   "position": Vector2(414, 110)}, 
					   3: {"text": "Na 2ª iteração podemos reparar que aumentou o valor do triângulo branco para 1 devido a contagem. E o triângulo vermelho devido a 1ª iteração onde a expressão \"0 + 1 + 2 = 3\"",
						   "position": Vector2(414, 110)},
					   4: {"text": "E a 3ª e última iteração. Contador triângulo branco aumenta mais 1. E o triângulo vermelho possui o valor 6 devido a 2º iteração com a expressão \"1 + 3 + 2\"",
						   "position": Vector2(414, 110)},
					   5: {"text": "Após completar as 3 repetições do escopo do for, é executado a próxima linha.",
						   "position": Vector2(359, 139)}}

func _ready() -> void:
	$red_square.visible = false
	$forr.play_idle()
	config_button()
	init_tutorial()

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
