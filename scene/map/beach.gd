extends Control

export (int) var qtd_less = 2
var in_map_less = 0

export (int) var qtd_bigger = 2
var in_map_bigger = 0

export (int) var qtd_equal = 2
var in_map_equal = 0

export (int) var qtd_nott = 2
var in_map_nott = 0

export (int) var qtd_andd = 2
var in_map_andd = 0

export (int) var qtd_orr = 2
var in_map_orr = 0

onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()

onready var market: Resource = load("res://scene/interface/market.tscn")
onready var circuit: Resource = load("res://scene/chalenge/circuit_logic.tscn")
onready var question: Resource = load("res://scene/chalenge/analyze_algorithm.tscn")
onready var warning: Resource = load("res://scene/interface/warnig.tscn")

onready var less: Resource = load("res://scene/character/codemons/less.tscn")
onready var bigger: Resource = load("res://scene/character/codemons/bigger.tscn")
onready var equal: Resource = load("res://scene/character/codemons/equal.tscn")
onready var nott: Resource = load("res://scene/character/codemons/not_equal.tscn")
onready var andd: Resource = load("res://scene/character/codemons/andd.tscn")
onready var orr: Resource = load("res://scene/character/codemons/orr.tscn")

onready var spawn_area: Array = [$spawn/a1, $spawn/a2, $spawn/a3, $spawn/a4, 
								$spawn/a5, $spawn/a6, $spawn/a7, $spawn/a8]
								

var next_map: String = ""
var codemon_chalenge: Node
var is_interact: bool = false
var in_dialog : bool = true

signal end_dialogue(reference)

func _ready() -> void:
	config_position_player()
	init_transition()
	connect("end_dialogue", self, "_on_end_dialogue")
	game.current_map = game.MAP_BEACH
	game.map_visited = 4 if game.map_visited < 4 else game.map_visited


func init_dialogue_beach() -> void:
	if game.dialogue_beach:
		$ysort/player.play_animation("", true)
		game.run_dialogue("beach_tutorial", self)
		game.dialogue_beach = false
	else:
		in_dialog = false


func _process(delta: float) -> void:
	in_map_less = in_map_less + check_area(less, in_map_less, qtd_less)
	in_map_bigger = in_map_bigger + check_area(bigger, in_map_bigger, qtd_bigger)
	in_map_equal = in_map_equal + check_area(equal, in_map_equal, qtd_equal)
	in_map_nott = in_map_nott + check_area(nott, in_map_nott, qtd_nott)
	in_map_andd = in_map_andd + check_area(andd, in_map_andd, qtd_andd)
	in_map_orr = in_map_orr + check_area(orr, in_map_orr, qtd_orr)


func init_transition() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")

func config_position_player() -> void:
	if game.current_map == game.MAP_MOUNTAIN:
		$ysort/player.play_animation("idle_down", true)
		$ysort/player.set("position", Vector2(1086,156))
	elif game.current_map == game.MAP_DESERT:
		$ysort/player.play_animation("idle_left", true)
		$ysort/player.set("position", Vector2(1669,-636))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		init_dialogue_beach()
		is_interact = true
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/"+ next_map + ".tscn")


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()


func _on_portal_mountain_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/mountain.ogg"))
	next_map = "mountain"


func _on_portal_desert_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/desert.ogg"))
	next_map = "desert"


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


func _on_chalenge_entered(object: String, node: Node) -> void:
	if !in_dialog:
		codemon_chalenge = node
		game.add_interaction_btn($ysort/player, tr("CHALLENGE"), object)
	
	
func _on_chalenge_exited(object: String) -> void:
	for child in $ysort/player.get_children():
		if child.is_class("Control") and child.get_node("object").text == object:
			$ysort/player.remove_child(child)
			pass

func _on_pick_talk_interaction(object: String) -> void:
	_on_chalenge_exited(object)
	if object == tr("DR"):
		in_dialog = true
		$ysort/player.play_animation("", true)
		game.run_dialogue("beach_tutorial", self)
	elif object == tr("STORE"):
		hud.add_child(market.instance())
		get_tree().paused = true
	elif object == tr("BATTERY"):
		hud.add_child(circuit.instance())
		get_tree().paused = true
	else:
		init_chalenge_codemon(object)

func repopulate(node: Node) -> void:
	in_map_equal = in_map_equal - 1 if node.codemon == "Equal" else in_map_equal
	in_map_nott =  in_map_nott -1 if node.codemon == "Not Equal" else in_map_nott
	in_map_less = in_map_less -1 if node.codemon == "Less" else in_map_less
	in_map_bigger = in_map_bigger -1 if node.codemon == "Bigger" else in_map_bigger
	in_map_andd = in_map_andd -1 if node.codemon == "And" else in_map_andd
	in_map_orr = in_map_orr -1 if node.codemon == "Or" else in_map_orr

func init_chalenge_codemon(codemon: String) -> void:
	if game.energy >= 2:
		game.subtract_energy()
		repopulate(codemon_chalenge)
		codemon_chalenge.queue_free()
		var chalenge: Control = question.instance()
		chalenge.codemon_chalenged = String(codemon).to_lower().replace(" ", "_")
		if game.show_tutorial_analyze_2:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/analyze_2.tscn").instance()
			hud.add_child(tutorial)
			yield(tutorial, "tree_exited")
		get_tree().paused = false
		hud.add_child(chalenge)
		get_tree().paused = true
		in_dialog = false
	else:
		var message: Control = warning.instance()
		message.type = "no_battery"
		hud.add_child(message)
		get_tree().paused = true


func _on_end_dialogue(reference: String) -> void:
	in_dialog = false
	$ysort/player.play_animation("", false)


func _on_dr_beach_chat_entered() -> void:
	in_dialog = true
	if is_interact:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))


func _on_dr_beach_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("DR"))


func _on_merchant_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("ACESS"), tr("STORE"))


func _on_merchant_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("STORE"))


func _on_doorman_chat_entered() -> void:
	in_dialog = true
	if game.is_completed_beach_capture():
		$tilemap/portal_desert/collision.set_deferred("disabled", false)
	else:
		$tilemap/portal_desert/collision.set_deferred("disabled", true)
		$ysort/player.play_animation("", true)
		game.run_dialogue("doorman", self)


func _on_doorman_chat_exited() -> void:
	in_dialog = false
	if !game.is_completed_beach_capture():
		game.is_chated_doorman = true


func _on_plug_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("RECHARGE"), tr("BATTERY"))


func _on_plug_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("BATTERY"))
