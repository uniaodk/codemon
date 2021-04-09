extends Control

var seq: Dictionary = {0: {"text": "Para recarregar o notebook, é necessário que a saída do circuito seja 1, uma linha verde. Mas para isso é necessário conhecer as portas lógicas.",
						   "position": Vector2(518, 140)},
					   1: {"text": "OR / Ou - Essa porta emite a saída 1, se pelo menos uma entrada estiver emitindo o sinal 1.",
						   "position": Vector2(285, 38)},
					   2: {"text": "AND / E - Essa porta emite a saída 1, somente se todas as entradas estiverem emitindo o sinal 1.",
						   "position": Vector2(442, 111)},
					   3: {"text": "XOR / Exclusiva - Essa porta emite a saída 1, somente se as entradas forem diferentes uma da outra.",
						   "position": Vector2(277, 199)},
					   4: {"text": "NOT / Inversora - Inverte o sinal emitido.",
						   "position": Vector2(156, 201)},
					   5: {"text": "Caso necessário utilize o botão de ajuda para relembrar esses conceitos.",
						   "position": Vector2(321, 355)},
					   6: {"text": "Para alterar o sinal de entrada, basta clicar em um desses 4 botões. Clique no primeiro botão.",
						   "position": Vector2(76, 0)},
					   7: {"text": "Agora clique no terceiro botão.",
						   "position": Vector2(67, 161)},
					   8: {"text": "No momento que conseguir emitir 1 como saída, a bateria é recarregada e novo desafio é gerado.",
						   "position": Vector2(609, 41)},
					   9: {"text": "Você pode retornar para sua aventura no momento que quiser clicando em voltar.",
						   "position": Vector2(516, 354)}}


func _ready() -> void:
	$zero_one/btn_4._on_zero_one_button_down()
	$zero_one/btn_4.disabled = true
	$zero_one/btn_2.disabled = true
	$help.disabled = true
	$back.disabled = true
	init_tutorial()

func init_tutorial() -> void:
	for i in range(seq.size()):
		var vis_ok: bool = true
		if [6, 7].has(i):
			$tip/ok.visible = false
			vis_ok = false
		$tip.show_tip(seq.get(i).get("text"), seq.get(i).get("position"), vis_ok)
		yield($tip/tween, "tween_completed")
		$zero_one/btn_1.disabled = i != 6
		$zero_one/btn_3.disabled = i != 7
		yield($tip/ok, "pressed")
	$tip.visible = false
	$back.disabled = false
	game.show_tutorial_circuit = false


func _on_btn_1_pressed() -> void:
	$zero_one/btn_1.disabled = true
	$first/connection_1.texture = load("res://art/chalenge/circuit_logic/lin_on.png")
	$third/connection_1.texture = load("res://art/chalenge/circuit_logic/curve_on.png")
	$tip/ok.visible = true


func _on_btn_3_pressed() -> void:
	$zero_one/btn_3.disabled = true
	$first/connection_3.texture = load("res://art/chalenge/circuit_logic/not_on.png")
	$third/connection_2.texture = load("res://art/chalenge/circuit_logic/curve_on.png")
	$last_connection.texture = load("res://art/chalenge/circuit_logic/lin_on.png")
	$notebook.texture = load("res://art/chalenge/circuit_logic/on.png")
	$battery.frame = 3
	$animation.play("on")
	$tip/ok.visible = true


func _on_back_pressed() -> void:
	queue_free()
