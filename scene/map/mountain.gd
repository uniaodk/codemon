extends Control

export (int) var qtd_plus = 2
var in_map_plus = 0

export (int) var qtd_minus = 2
var in_map_minus = 0

export (int) var qtd_multi = 2
var in_map_multi = 0

export (int) var qtd_divide = 2
var in_map_divide = 0

export (int) var qtd_module = 2
var in_map_module = 0

onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()

onready var market: Resource = load("res://scene/interface/market.tscn")
onready var circuit: Resource = load("res://scene/chalenge/circuit_logic.tscn")
onready var question: Resource = load("res://scene/chalenge/analyze_algorithm.tscn")
onready var warning: Resource = load("res://scene/interface/warnig.tscn")

onready var plus: Resource = load("res://scene/character/codemons/plus.tscn")
onready var minus: Resource = load("res://scene/character/codemons/minus.tscn")
onready var multi: Resource = load("res://scene/character/codemons/multiply.tscn")
onready var divide: Resource = load("res://scene/character/codemons/divide.tscn")
onready var module: Resource = load("res://scene/character/codemons/modulo.tscn")

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
	game.current_map = game.MAP_MOUNTAIN
	game.map_visited = 3 if game.map_visited < 3 else game.map_visited

func init_dialogue_mountain() -> void:
	if game.dialogue_mountain:
		$ysort/player.play_animation("", true)
		game.run_dialogue("mountain_tutorial", self)
		game.dialogue_mountain = false
	else:
		in_dialog = false

func _process(delta: float) -> void:
	in_map_plus = in_map_plus + check_area(plus, in_map_plus, qtd_plus)
	in_map_minus = in_map_minus + check_area(minus, in_map_minus, qtd_minus)
	in_map_multi = in_map_multi + check_area(multi, in_map_multi, qtd_multi)
	in_map_divide = in_map_divide + check_area(divide, in_map_divide, qtd_divide)
	in_map_module = in_map_module + check_area(module, in_map_module, qtd_module)


func init_transition() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")

func config_position_player() -> void:
	if game.current_map == game.MAP_FOREST:
		$ysort/player.play_animation("idle_up", true)
		$ysort/player.set("position", Vector2(277,502))
	elif game.current_map == game.MAP_BEACH:
		$ysort/player.play_animation("idle_left", true)
		$ysort/player.set("position", Vector2(1952,177))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		init_dialogue_mountain()
		is_interact = true
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/"+ next_map + ".tscn")


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()


func _on_portal_forest_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/forest.ogg"))
	next_map = "forest"


func _on_portal_beach_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/beach.ogg"))
	next_map = "beach"


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
		game.run_dialogue("mountain_tutorial", self)
	elif object == tr("STORE"):
		hud.add_child(market.instance())
		get_tree().paused = true
	elif object == tr("BATTERY"):
		hud.add_child(circuit.instance())
		get_tree().paused = true
	else:
		init_chalenge_codemon(object)

func repopulate(node: Node) -> void:
	in_map_divide =  in_map_divide - 1 if node.codemon == "Divide" else in_map_divide
	in_map_multi =  in_map_multi -1 if node.codemon == "Multiply" else in_map_multi
	in_map_plus = in_map_plus -1 if node.codemon == "Plus" else in_map_plus
	in_map_minus = in_map_minus -1 if node.codemon == "Minus" else in_map_minus
	in_map_module = in_map_module -1 if node.codemon == "Modulo" else in_map_module

func init_chalenge_codemon(codemon: String) -> void:
	if game.energy >= 2:
		game.subtract_energy()
		repopulate(codemon_chalenge)
		codemon_chalenge.queue_free()
		var chalenge: Control = question.instance()
		chalenge.codemon_chalenged = String(codemon).to_lower()
		if game.show_tutorial_analyze_1:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/analyze_1.tscn").instance()
			hud.add_child(tutorial)
			yield(tutorial, "tree_exited")
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


func _on_merchant_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("ACESS"), tr("STORE"))


func _on_merchant_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("STORE"))


func _on_doorman_chat_entered() -> void:
	in_dialog = true
	if game.is_completed_mountain_capture():
		$tilemap/portal_beach/collision.set_deferred("disabled", false)
	else:
		$tilemap/portal_beach/collision.set_deferred("disabled", true)
		$ysort/player.play_animation("", true)
		game.run_dialogue("doorman", self)


func _on_doorman_chat_exited() -> void:
	in_dialog = false
	if !game.is_completed_mountain_capture():
		game.is_chated_doorman = true


func _on_plug_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("RECHARGE"), tr("BATTERY"))


func _on_plug_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("BATTERY"))


func _on_dr_mountain_chat_entered() -> void:
	in_dialog = true
	if is_interact:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))


func _on_dr_mountain_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("DR"))
