extends Control

export (int) var qtd_iff = 2
var in_map_iff = 0

export (int) var qtd_elsee = 2
var in_map_elsee = 0

export (int) var qtd_forr = 2
var in_map_forr = 0

export (int) var qtd_whilee = 2
var in_map_whilee = 0

onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()

onready var market: Resource = load("res://scene/interface/market.tscn")
onready var circuit: Resource = load("res://scene/chalenge/circuit_logic.tscn")
onready var question: Resource = load("res://scene/chalenge/analyze_algorithm.tscn")
onready var warning: Resource = load("res://scene/interface/warnig.tscn")

onready var iff: Resource = load("res://scene/character/codemons/iff.tscn")
onready var elsee: Resource = load("res://scene/character/codemons/elsee.tscn")
onready var forr: Resource = load("res://scene/character/codemons/forr.tscn")
onready var whilee: Resource = load("res://scene/character/codemons/whilee.tscn")

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
	game.current_map = game.MAP_DESERT
	game.map_visited = 5 if game.map_visited < 5 else game.map_visited


func init_dialogue_desert() -> void:
	if game.dialogue_desert:
		$ysort/player.play_animation("", true)
		game.run_dialogue("desert_tutorial", self)
		game.dialogue_desert = false
	else:
		in_dialog = false


func _process(delta: float) -> void:
	in_map_iff = in_map_iff + check_area(iff, in_map_iff, qtd_iff)
	in_map_elsee = in_map_elsee + check_area(elsee, in_map_elsee, qtd_elsee)
	in_map_forr = in_map_forr + check_area(forr, in_map_forr, qtd_forr)
	in_map_whilee = in_map_whilee + check_area(whilee, in_map_whilee, qtd_whilee)


func init_transition() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")

func config_position_player() -> void:
	if game.current_map == game.MAP_BEACH:
		$ysort/player.play_animation("idle_up", true)
		$ysort/player.set("position", Vector2(433,474))
	elif game.current_map == game.MAP_BOSS:
		$ysort/player.play_animation("idle_down", true)
		$ysort/player.set("position", Vector2(1614,135))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		init_dialogue_desert()
		is_interact = true
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/"+ next_map + ".tscn")


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()


func _on_portal_boss_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/boss_defeated.ogg") if game.is_finished_game
					  else load("res://audio/music/boss.ogg"))
	next_map = "boss"


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
		game.run_dialogue("desert_tutorial", self)
	elif tr("STORE"):
		hud.add_child(market.instance())
		get_tree().paused = true
	elif tr("BATTERY"):
		hud.add_child(circuit.instance())
		get_tree().paused = true
	else:
		init_chalenge_codemon(object)
			
func repopulate(node: Node) -> void:
	in_map_forr = in_map_forr - 1 if node.codemon == "For" else in_map_forr
	in_map_whilee =  in_map_whilee -1 if node.codemon == "While" else in_map_whilee
	in_map_iff = in_map_iff -1 if node.codemon == "If" else in_map_iff
	in_map_elsee = in_map_elsee -1 if node.codemon == "Else" else in_map_elsee


func init_chalenge_codemon(codemon: String) -> void:
	if game.energy >= 2:
		game.subtract_energy()
		repopulate(codemon_chalenge)
		codemon_chalenge.queue_free()
		var chalenge: Control = question.instance()
		chalenge.codemon_chalenged = String(codemon).to_lower()
		if codemon == "If" and game.show_tutorial_if:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/if_tutorial.tscn").instance()
			hud.add_child(tutorial)
			yield(tutorial, "tree_exited")
		elif codemon == "Else" and game.show_tutorial_else:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/else_tutorial.tscn").instance()
			hud.add_child(tutorial)
			yield(tutorial, "tree_exited")
		elif codemon == "For" and game.show_tutorial_for:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/for_tutorial.tscn").instance()
			hud.add_child(tutorial)
			yield(tutorial, "tree_exited")
		elif codemon == "While" and game.show_tutorial_while:
			get_tree().paused = true
			var tutorial: Control = load("res://scene/tutorial/while_tutorial.tscn").instance()
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


func _on_dr_desert_chat_entered() -> void:
	in_dialog = true
	if is_interact:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))


func _on_dr_desert_chat_exited() -> void:
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
	if game.is_completed_desert_capture():
		$tilemap/portal_boss/collision.set_deferred("disabled", false)
	else:
		$tilemap/portal_boss/collision.set_deferred("disabled", true)
		$ysort/player.play_animation("", true)
		game.run_dialogue("doorman", self)


func _on_doorman_chat_exited() -> void:
	in_dialog = false
	if !game.is_completed_desert_capture():
		game.is_chated_doorman = true


func _on_plug_chat_entered() -> void:
	in_dialog = true
	game.add_interaction_btn($ysort/player, tr("RECHARGE"), tr("BATTERY"))


func _on_plug_chat_exited() -> void:
	in_dialog = false
	_on_chalenge_exited(tr("BATTERY"))
