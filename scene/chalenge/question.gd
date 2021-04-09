extends Control

const codemons: Dictionary = {"int" : "res://scene/character/codemons/intt.tscn",
							"double" : "res://scene/character/codemons/double.tscn",
							"string" : "res://scene/character/codemons/string.tscn",
							"bool" : "res://scene/character/codemons/booll.tscn"}
export (String) var codemon_chalenged
var is_simulation: bool = false

onready var success: Control = load("res://scene/interface/feedback_ok.tscn").instance()
onready var fail: Control = load("res://scene/interface/feedback_fail.tscn").instance()
onready var tutorial: Control = load("res://scene/tutorial/question.tscn").instance()
onready var help: Resource = load("res://scene/interface/help.tscn")

var options: Array = ["a", "b", "c"]

var question: Dictionary
var option_selected: String
var awnser_selected: String

var correct: String

func _ready() -> void:
	translation();
	if game.show_tutorial_question:
		add_child(tutorial)
		yield(tutorial, "tree_exited")
	update_status()
	init_sprite()
	question = random_question()
	init_chalenge()
	$options/a.grab_focus()

func translation() -> void:
	$title.text = tr("STAGE_1_TITLE");
	$question.text = tr("STAGE_1_DESC");
	$capture/btn_name.text = tr("CAPTURE");
	$help/btn_name.text = tr("HELP");
	$flee/btn_name.text = tr("FLEE");

func update_status() -> void:
	$battery.frame = 10 - game.energy
	$animation.play("shake")
	var id_codemon_chalenged: int = game.codemon_name.values().find(codemon_chalenged)


func init_sprite() -> void:
	var sprite: KinematicBody2D = load(codemons.get(codemon_chalenged)).instance()
	sprite.position = Vector2(765, 350)
	sprite.play_idle()
	add_child(sprite)

func random_question() -> Dictionary:
	var questions: Array = persistence.get("questions_" + codemon_chalenged)
	randomize()
	var index: int = randi() % questions.size()
	return questions[index]

func init_chalenge() -> void:
	$chalenge.text = tr("CHALLENGING") + " " + codemon_chalenged.capitalize()
	$question.text = question.get("question")
	randomize()
	correct = options[randi() % 3]
	write_awnsers()


func write_awnsers() -> void:
	var awnser_previous: String = ""
	for i in range(3):
		var awnser: String = ""
		if options[i] == correct:
			awnser = random_awnser(question.get("correct"))
		else:
			while(awnser_previous == awnser or awnser.empty()):
				awnser = random_awnser(question.get("wrong"))
			awnser_previous = awnser
		$options.get_node(options[i]).get_node("awnser").text = awnser


func random_awnser(awnsers: Array) -> String:
	randomize()
	var index: int = randi() % awnsers.size()
	return String(awnsers[index])


func update_options() -> void:
	$capture.disabled = false
	$capture/btn_name.set("custom_colors/font_color", Color.black)
	$options/a.update_button(option_selected == 'a')
	$options/b.update_button(option_selected == 'b')
	$options/c.update_button(option_selected == 'c')

func coloring_options() -> void:
	for i in range(3):
		var color: Color = Color("0e9332") if options[i] == correct else Color.red
		$options.get_node(options[i]).get_node("awnser").set("custom_colors/font_color", color)


func _on_a_pressed() -> void:
	option_selected = 'a'
	update_options()

func _on_b_pressed() -> void:
	option_selected = 'b'
	update_options()

func _on_c_pressed() -> void:
	option_selected = 'c'
	update_options()


func _on_flee_pressed() -> void:
	get_tree().paused = false
	queue_free()


func lost_focus() -> void:
	$options/a.focus_mode = Control.FOCUS_NONE
	$options/b.focus_mode = Control.FOCUS_NONE
	$options/c.focus_mode = Control.FOCUS_NONE
	$capture.focus_mode = Control.FOCUS_NONE
	$flee.focus_mode = Control.FOCUS_NONE
	

func _on_capture_pressed() -> void:
	lost_focus()
	coloring_options()
	if correct == option_selected:
		success.is_simulation = is_simulation
		success.codemon = game.codemon_name.values().find(codemon_chalenged)
		add_child(success)
	else:
		if !is_simulation:
			game.subtract_energy()
			$battery.frame = 10 - game.energy
			$animation.play("shake")
		fail.is_simulation = is_simulation
		fail.codemon = game.codemon_name.values().find(codemon_chalenged)
		add_child(fail)

func _on_help_pressed() -> void:
	var help_instance: CanvasLayer = help.instance()
	help_instance.set_image(codemon_chalenged)
	add_child(help_instance)
