extends Control

var interaction: int = 0

var seq: Dictionary = {0: {"text": "O comando de controle WHILE pode executar ou não seu escopo várias vezes, dependendo da expressão booleana ao seu lado.",
						   "position": Vector2(409, 82)},
					   1: {"text": "Digamos que a expressão seja 2 < 5, ou seja TRUE. Significa dizer que o escopo marcado com a caixa vermelha será executado até que essa condição se torne FALSE.",
						   "position": Vector2(495, 107)},
					   2: {"text": "Na 1ª iteração será executada a expressão \"2 + 2 = 4\" e atribuído ao triângulo vermelho. Onde a condição do WHILE \"4 < 5\" permanece TRUE",
						   "position": Vector2(495, 107)}, 
					   3: {"text": "Na 2ª iteração será executada a expressão \"4 + 2 = 6\" e atribuído a triângulo vermelho. Onde a condição do WHILE \"6 < 5\" se torna FALSE",
						   "position": Vector2(495, 107)}, 
					   4: {"text": "Quando a condição se torna FALSE, é executado a próxima linha.",
						   "position": Vector2(312, 163)},
					   5: {"text": "Mas tome cuidado em atribuir valores impossíveis de atender a condição do WHILE. Pois podem gerar uma repetição infinita.",
						   "position": Vector2(409, 82)},
					   6: {"text": "Digamos que ao invés de utilizar o operador lógico LESS, utilizaremos o NOT EQUAL.",
						   "position": Vector2(409, 82)},
					   7: {"text": "Com isso as condições do WHILE conforme iteração seriam \"2 != 5\", \"4 != 5\", \"6 != 5\". Podemos deduzir que nunca será FALSE a condição.",
						   "position": Vector2(409, 82)},
					   8: {"text": "Porque o valor do triângulo tende a crescer em 2, e se notarmos nunca poderá ter o valor 5 que é a única condição de saída do WHILE.",
						   "position": Vector2(409, 82)}}

func _ready() -> void:
	$red_square.visible = false
	$whilee.play_idle()
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
