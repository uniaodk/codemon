extends Control

var pos_btn_1: int 
var pos_btn_2: int 
var debug_count: int = 0

var first_debug: bool = true

var seq: Dictionary = {0: {"text": "O comando de controle ELSE só estará presente quando houver um IF, pois, depende do IF para ser executado ou não",
						   "position": Vector2(481, 104)},
					   1: {"text": "Em outras palavras, se o IF executar o ELSE não executa, ou se o IF não executar o ELSE executa.",
						   "position": Vector2(362, 85)},
					   2: {"text": "Vamos iniciar um exemplo para ficar mais fácil de entender, digamos que atribuição das formas ficou desse jeito.",
						   "position": Vector2(362, 85)},
					   3: {"text": "Como 2 é menor que 3, o IF tem condição TRUE, o que permite a execução do seu escopo.",
						   "position": Vector2(441, 110)},
					   4: {"text": "E como IF é TRUE, ELSE é FALSE. Consequentemente não é executado o escopo do ELSE.",
						   "position": Vector2(442, 203)},
					   5: {"text": "Agora vamos iniciar o outro cenário.",
						   "position": Vector2(362, 85)},
					   6: {"text": "Nessa situação 4 não é menor que 3, então o IF tem condição FALSE, o que faz pular o seu escopo.",
						   "position": Vector2(441, 110)},
					   7: {"text": "E como IF é FALSE, ELSE é TRUE. Consequentemente é executado o escopo do ELSE.",
						   "position": Vector2(442, 203)}}

func _ready() -> void:
	$elsee.play_idle()
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
