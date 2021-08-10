	extends Control

export (int) var qtd_int = 3
var in_map_int = 0

export (int) var qtd_double = 3
var in_map_double = 0

export (int) var qtd_string = 3
var in_map_string = 0

export (int) var qtd_bool = 3
var in_map_bool = 0

onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()

onready var market: Resource = load("res://scene/interface/market.tscn")
onready var circuit: Resource = load("res://scene/chalenge/circuit_logic.tscn")
onready var question: Resource = load("res://scene/chalenge/question.tscn")
onready var warning: Resource = load("res://scene/interface/warnig.tscn")

onready var intt: Resource = load("res://scene/character/codemons/intt.tscn")
onready var double: Resource = load("res://scene/character/codemons/double.tscn")
onready var string: Resource = load("res://scene/character/codemons/string.tscn")
onready var booll: Resource = load("res://scene/character/codemons/booll.tscn")

onready var spawn_area: Array = [$spawn/a1, $spawn/a2, $spawn/a3, $spawn/a4, 
								$spawn/a5, $spawn/a6, $spawn/a7, $spawn/a8]

var next_map: String = ""
var codemon_chalenge: Node
var is_interact: bool = true
var in_dialog : bool = true

signal end_dialogue(reference)

func _ready() -> void:
	config_position_player()
	init_transition()
	connect("end_dialogue", self, "_on_end_dialogue")
	game.current_map = game.MAP_FOREST
	game.map_visited = 2 if game.map_visited < 2 else game.map_visited


func init_dialogue_forest() -> void:
	if game.dialogue_forest:
		$ysort/player.play_animation("", true)
		game.run_dialogue("forest_tutorial", self)
		game.dialogue_forest = false
	else:
		in_dialog = false


func _process(delta: float) -> void:
	in_map_int = in_map_int + check_area(intt, in_map_int, qtd_int)
	in_map_double = in_map_double + check_area(double, in_map_double, qtd_double)
	in_map_string = in_map_string + check_area(string, in_map_string, qtd_string)
	in_map_bool = in_map_bool + check_area(booll, in_map_bool, qtd_bool)

func init_transition() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")


func config_position_player() -> void:
	if game.current_map == game.MAP_STREET:
		$ysort/player.play_animation("idle_right", true)
		$ysort/player.set("position", Vector2(152,321))
	elif game.current_map == game.MAP_MOUNTAIN:
		$ysort/player.play_animation("idle_down", true)
		$ysort/player.set("position", Vector2(1191,-724))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		init_dialogue_forest()
		is_interact = true
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/"+ next_map + ".tscn")


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()
	elif anim_name == "transition_in": 
		$ysort/player.play_animation("", true)

func _on_portal_street_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/street_laboratory.ogg"))
	next_map = "street"


func _on_portal_mountain_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/mountain.ogg"))
	next_map = "mountain"


func check_area(codemon_rsc: Resource, in_map: int, qtd: int) -> int:
	if  in_map < qtd:
		randomize()
		var codemon: KinematicBody2D = codemon_rsc.instance()
		codemon.position = create_position()
		$ysort.add_child(codemon)
		return 1
	else:
		return 0


func create_position() -> Vector2:
	var index: int = randi() % spawn_area.size()
	var center: Vector2 = spawn_area[index].rect_position
	var size: Vector2 =  spawn_area[index].rect_size
	var vector: Vector2 = Vector2.ZERO
	vector.x = (randi() % int(size.x) / 2) + center.x
	vector.y = (randi() % int(size.y) / 2) + center.y
	return vector


func _on_chalenge_entered(codemon: String, node: Node) -> void:
	if !in_dialog:
		codemon_chalenge = node
		game.add_interaction_btn($ysort/player, tr("CHALLENGE"), codemon)


func _on_chalenge_exited(object) -> void:
	for child in $ysort/player.get_children():
		if child.is_class("Control") and child.get_node("object").text == object:
			$ysort/player.remove_child(child)
			pass


func _on_merchant_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("ACESS"), tr("STORE"))


func _on_merchant_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("STORE"))


func _on_doorman_chat_entered() -> void:
	in_dialog = true
	if game.is_completed_forest_capture():
		$tilemap/portal_mountain/collision.set_deferred("disabled", false)
	else:
		$tilemap/portal_mountain/collision.set_deferred("disabled", true)
		$ysort/player.play_animation("", true)
		game.run_dialogue("doorman", self)


func _on_doorman_chat_exited() -> void:
	in_dialog = false
	if !game.is_completed_forest_capture():
		game.is_chated_doorman = true


func _on_plug_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("RECHARGE"), tr("BATTERY"))


func _on_plug_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("BATTERY"))


func _on_dr_forest_chat_entered() -> void:
	in_dialog = true
	if is_interact:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))


func _on_dr_forest_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("DR"))


func _on_pick_talk_interaction(object: String) -> void:
	_on_chalenge_exited(object)
	if object == tr("DR"):
		in_dialog = true
		$ysort/player.play_animation("", true)
		game.run_dialogue("forest_tutorial", self)
	elif object == tr("STORE"):
		hud.add_child(market.instance())
		get_tree().paused = true
	elif object == tr("BATTERY"):
		hud.add_child(circuit.instance())
		get_tree().paused = true
	else:
		init_chalenge_codemon(object)


func repopulate(node: Node) -> void:
	in_map_int =  in_map_int - 1 if node.codemon == "Int" else in_map_int
	in_map_double =  in_map_double -1 if node.codemon == "Double" else in_map_double
	in_map_string = in_map_string -1 if node.codemon == "String" else in_map_string
	in_map_bool = in_map_bool -1 if node.codemon == "Bool" else in_map_bool

func init_chalenge_codemon(codemon: String) -> void:
	if game.energy >= 2:
		game.subtract_energy()
		repopulate(codemon_chalenge)
		codemon_chalenge.queue_free()
		var chalenge: Control = question.instance()
		chalenge.codemon_chalenged = String(codemon).to_lower()
		hud.add_child(chalenge)
		get_tree().paused = true
		in_dialog = false
	else:
		var message: Control = warning.instance()
		message.type = "no_battery"
		hud.add_child(message)
		get_tree().paused = true


func _on_end_dialogue(reference: String) -> void:
	$ysort/player.play_animation("", false)
	in_dialog = false
