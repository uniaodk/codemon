extends Control

onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()
onready var question: Resource = load("res://scene/chalenge/bubble_sort.tscn")
onready var simulator: Resource = load("res://scene/chalenge/simulator.tscn")

onready var bubble_good: Resource = load("res://scene/character/codemons/bubble_good.tscn")
onready var bubble_bad: Resource = load("res://scene/character/codemons/bubble_bad.tscn")

var bubble: KinematicBody2D 

signal end_dialogue(reference)
var is_interact: bool = false

func _ready() -> void:
	init_bubble()
	config_position_player()
	init_transition()
	connect("end_dialogue", self, "_on_end_dialogue")
	game.current_map = game.MAP_BOSS
	game.map_visited = 6 if game.map_visited < 6 else game.map_visited
	$ysort/player.play_animation("", true)

func init_dialogue_boss() -> void:
	if game.dialogue_boss:
		$ysort/player.play_animation("", true)
		game.run_dialogue("boss_tutorial", self)
		game.dialogue_boss = false

func init_bubble() -> void:
	bubble = (bubble_good.instance() 
			 if game.is_finished_game
			 else bubble_bad.instance())
	bubble.position = Vector2(277, 269)
	bubble.scale = Vector2(3, 3)
	bubble.play_idle()
	$ysort.add_child(bubble)

func init_transition() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")

func config_position_player() -> void:
	if game.current_map == game.MAP_DESERT:
		$ysort/player.play_animation("idle_up", true)
		$ysort/player.set("position", Vector2(515,525))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		is_interact = true
		init_dialogue_boss()
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/desert.tscn")


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()


func _on_portal_desert_body_entered(body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/desert.ogg"))

func _on_chalenge_entered(object, _node) -> void:
	if object == tr("INFECTED_BUBBLE"):
		game.add_interaction_btn($ysort/player, tr("CHALLENGE"), tr("INFECTED_BUBBLE"))
	else:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("BUBBLE"))	

func _on_chalenge_exited(object) -> void:
	for child in $ysort/player.get_children():
		if child.is_class("Control") and child.get_node("object").text == object:
			$ysort/player.remove_child(child)
			pass

func _on_dr_compilador_chat_entered() -> void:
	if is_interact:
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))

func _on_dr_compilador_chat_exited() -> void:
	_on_chalenge_exited(tr("DR"))
	
func _on_pick_talk_interaction(object: String) -> void:
	_on_chalenge_exited(object)
	if object == tr("DR"):
		$ysort/player.play_animation("", true)
		game.run_dialogue("boss_tutorial", self)
	elif object == tr("BUBBLE"):
		$ysort/player.play_animation("", true)
		game.run_dialogue("bubble_good", self)
	elif object == tr("SIMULATOR"):
		if game.is_finished_game:
			var simulation: Control = simulator.instance()
			hud.add_child(simulation)
			get_tree().paused = true
		else:
			$ysort/player.play_animation("", true)
			game.run_dialogue("simulator", self)
	else:
		init_chalenge_bubble()

func _on_end_dialogue(reference: String) -> void:
	$ysort/player.play_animation("", false)

func init_chalenge_bubble() -> void:
	var chalenge: Control = question.instance()
	if game.show_tutorial_bubble:
		get_tree().paused = true
		var tutorial: Control = load("res://scene/tutorial/tutorial_bubble.tscn").instance()
		hud.add_child(tutorial)
		yield(tutorial, "tree_exited")
	get_tree().paused = false
	hud.add_child(chalenge)
	get_tree().paused = true

func end_game() -> void:
	game.change_music(load("res://audio/music/boss_defeated.ogg"))
	$ysort.remove_child(bubble)
	bubble = bubble_good.instance()
	bubble.position = Vector2(277, 269)
	bubble.scale = Vector2(3, 3)
	bubble.play_idle()
	$ysort.add_child(bubble)


func _on_computer_chat_entered() -> void:
	game.add_interaction_btn($ysort/player, tr("ACESS"), tr("SIMULATOR"))


func _on_computer_chat_exited() -> void:
	_on_chalenge_exited(tr("SIMULATOR"))
