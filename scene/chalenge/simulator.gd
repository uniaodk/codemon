extends Control


onready var question: Resource = load("res://scene/chalenge/question.tscn")
onready var analize: Resource = load("res://scene/chalenge/analyze_algorithm.tscn")
onready var bubble: Resource = load("res://scene/chalenge/bubble_sort.tscn")
onready var circuit: Resource = load("res://scene/chalenge/circuit_logic.tscn")


func _ready() -> void:
	init_translation();
	$check_box.is_checked = false
	$check_box._on_check_box_pressed()

func init_translation() -> void:
	$title.text = tr("SIMULATOR");
	$question.text = tr("SIMULATOR_DESC");
	$check_box/text.text = tr("SHOW_TUTORIAL");
	$back/btn_name.text = tr("BACK");

func init_chalenge(codemon: String, tutorial_name: String, resource: Resource) -> void:
	var chalenge: Control = resource.instance()
	if !$check_box.is_checked:
		var tutorial: Control = load("res://scene/tutorial/"+ tutorial_name +".tscn").instance()
		add_child(tutorial)
		yield(tutorial, "tree_exited")
	if !["bubble", "plug"].has(codemon):
		chalenge.codemon_chalenged = codemon
	chalenge.is_simulation = true
	add_child(chalenge)


func _on_int_pressed() -> void:
	init_chalenge("int", "question", question)


func _on_double_pressed() -> void:
	init_chalenge("double", "question", question)


func _on_string_pressed() -> void:
	init_chalenge("string", "question", question)


func _on_bool_pressed() -> void:
	init_chalenge("bool", "question", question)


func _on_plus_pressed() -> void:
	init_chalenge("plus", "analyze_1", analize)


func _on_minus_pressed() -> void:
	init_chalenge("minus", "analyze_1", analize)


func _on_multiply_pressed() -> void:
	init_chalenge("multiply", "analyze_1", analize)


func _on_divide_pressed() -> void:
	init_chalenge("divide", "analyze_1", analize)


func _on_modulo_pressed() -> void:
	init_chalenge("modulo", "analyze_1", analize)


func _on_equal_pressed() -> void:
	init_chalenge("equal", "analyze_2", analize)


func _on_not_equal_pressed() -> void:
	init_chalenge("not_equal", "analyze_2", analize)


func _on_less_pressed() -> void:
	init_chalenge("less", "analyze_2", analize)


func _on_bigger_pressed() -> void:
	init_chalenge("bigger", "analyze_2", analize)


func _on_and_pressed() -> void:
	init_chalenge("and", "analyze_2", analize)


func _on_or_pressed() -> void:
	init_chalenge("or", "analyze_2", analize)


func _on_for_pressed() -> void:
	init_chalenge("for", "for_tutorial", analize)


func _on_while_pressed() -> void:
	init_chalenge("while", "while_tutorial", analize)


func _on_if_pressed() -> void:
	init_chalenge("if", "if_tutorial", analize)


func _on_else_pressed() -> void:
	init_chalenge("else", "else_tutorial", analize)


func _on_plug_pressed() -> void:
	init_chalenge("plug", "circuit", circuit)


func _on_bubble_pressed() -> void:
	init_chalenge("bubble", "tutorial_bubble", bubble)
	

func _on_back_pressed() -> void:
	get_tree().paused = false
	queue_free()
