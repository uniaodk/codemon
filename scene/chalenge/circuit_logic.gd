extends Control

const CONNECTIONS: Array = ["lin", "not"]
const GATES: Array = ["and", "or", "xor"]

var input: Array = [false, false, false, false, false, false]
var output: bool = false
var is_simulation: bool = false

onready var tutorial: Control = load("res://scene/tutorial/circuit.tscn").instance()
onready var help: Resource = load("res://scene/interface/help.tscn")

func _ready() -> void:
	init_translation();
	if game.show_tutorial_circuit:
		add_child(tutorial)
		yield(tutorial, "tree_exited")
	var start: bool = true
	$battery.frame = 10 - game.energy
	reset_buttons()
	while(start or output):
		input[0] = random_connection($first/connection_1, "_off")
		input[1] = random_connection($first/connection_2, "_off")
		input[2] = random_connection($first/connection_3, "_off")
		input[3] = random_connection($first/connection_4, "_off")
		input[4] = random_gate($second/gate_1, input[0], input[1])
		input[5] = random_gate($second/gate_2, input[2], input[3])
		update_curve_connection($third/connection_1, input[4])
		update_curve_connection($third/connection_2, input[5])
		output = random_gate($last_gate, input[4], input[5])
		output = update_last()
		update_notebook(false)
		start = false
	$zero_one/btn_1.grab_focus()

func init_translation() -> void:
	$title.text = tr("LOGIC_GATE");
	$help/btn_name.text = tr("HELP");
	$back/btn_name.text = tr("BACK");

func reset_buttons() -> void:
	$zero_one/btn_1.reset()
	$zero_one/btn_2.reset()
	$zero_one/btn_3.reset()
	$zero_one/btn_4.reset()
	

func update_first(btn: TextureButton, connection: TextureRect) -> bool:
	var path: String = connection.texture.resource_path.get_base_dir() + "/"
	var file: String = connection.texture.resource_path.get_file().substr(0, 3)
	var on_off: String = "_off" if btn.is_zero else "_on"
	connection.set_texture(load(path + file + on_off + ".png"))
	return !btn.is_zero if file == "lin" else btn.is_zero


func update_gate(gate: TextureRect, input_1: bool, input_2: bool) -> bool:
	var gate_name: String = gate.texture.resource_path.get_file().substr(0, 3)
	return output_gate(gate_name, input_1, input_2)


func update_curve_connection(connection: TextureRect, input: bool) -> void:
	var on_off: String = "_on" if input else "_off"
	connection.set_texture(load("res://art/chalenge/circuit_logic/curve"+ on_off +".png"))


func update_last_connection(connection: TextureRect) -> void:
	var connection_name: String = connection.texture.resource_path.get_file().substr(0, 3)
	var on_off: String = "_on" if output else "_off"
	output = !output if connection_name == "not" else output
	connection.set_texture(load("res://art/chalenge/circuit_logic/" + connection_name + on_off +".png"))


func update_last() -> bool:
	var is_not: bool = random_connection($last_connection, "_on" if output else "_off")
	return !output if is_not else output


func update_notebook(play: bool) -> void:
	var on_off: String = "on" if output else "off"
	$notebook.set_texture(load("res://art/chalenge/circuit_logic/"+ on_off +".png"))
	if output and play:
		if !is_simulation:
			game.energy = game.energy + 1 if game.energy < 10 else game.energy
		$battery.frame = 10 - game.energy
		$animation.play("on")

func random_connection(connection: TextureRect, on_off: String) -> bool:
	randomize()
	var index: int = randi() % CONNECTIONS.size()
	connection.set_texture(load("res://art/chalenge/circuit_logic/"+ CONNECTIONS[index] + on_off +".png"))
	return  CONNECTIONS[index] == 'not'


func random_gate(gate: TextureRect, input_1: bool, input_2: bool) -> bool:
	randomize()
	var index: int = randi() % GATES.size()
	gate.set_texture(load("res://art/chalenge/circuit_logic/"+ GATES[index] +".png"))
	return output_gate(GATES[index], input_1, input_2)


func output_gate(gate: String, input_1: bool, input_2: bool) -> bool:
	if gate == "and":
		return input_1 and input_2
	else:
		return input_1 != input_2 if gate == "xor" else input_1 or input_2


func _on_btn_1_pressed() -> void:
	input[0] = update_first($zero_one/btn_1, $first/connection_1)
	input[4] = update_gate($second/gate_1, input[0], input[1])
	update_curve_connection($third/connection_1, input[4])
	output = update_gate($last_gate, input[4], input[5])
	update_last_connection($last_connection)
	update_notebook(true)


func _on_btn_2_pressed() -> void:
	input[1] = update_first($zero_one/btn_2, $first/connection_2)
	input[4] = update_gate($second/gate_1, input[0], input[1])
	update_curve_connection($third/connection_1, input[4])
	output = update_gate($last_gate, input[4], input[5])
	update_last_connection($last_connection)
	update_notebook(true)


func _on_btn_3_pressed() -> void:
	input[2] = update_first($zero_one/btn_3, $first/connection_3)
	input[5] = update_gate($second/gate_2, input[2], input[3])
	update_curve_connection($third/connection_2, input[5])
	output = update_gate($last_gate, input[4], input[5])
	update_last_connection($last_connection)
	update_notebook(true)


func _on_btn_4_pressed() -> void:
	input[3] = update_first($zero_one/btn_4, $first/connection_4)
	input[5] = update_gate($second/gate_2, input[2], input[3])
	update_curve_connection($third/connection_2, input[5])
	output = update_gate($last_gate, input[4], input[5])
	update_last_connection($last_connection)
	update_notebook(true)


func _on_back_pressed() -> void:
	get_tree().paused = false
	persistence.save_progress()
	queue_free()


func _on_animation_finished(anim_name: String) -> void:
	_ready()

func _on_help_pressed() -> void:
	var help_instance: CanvasLayer = help.instance()
	help_instance.set_image("plug")
	add_child(help_instance)
