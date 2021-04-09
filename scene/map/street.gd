extends Control

var dialogue_scene : Resource = load("res://scene/interface/dialogue.tscn")
onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()
var next_map : String = ""

signal end_dialogue(reference)

func _ready() -> void:
	config_position_player()
	init_map()
	connect("end_dialogue", self, "_on_end_dialogue")
	game.current_map = game.MAP_STREET
	
func init_map() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")

func config_position_player() -> void:
	if game.current_map == game.MAP_FOREST:
		$ysort/player.play_animation("idle_left", true)
		$ysort/player.set("position", Vector2(904,368))
	elif game.current_map == game.MAP_LAB:
		$ysort/player.play_animation("idle_down", true)
		$ysort/player.set("position", Vector2(530,362))
	elif game.is_new_game:
		$ysort/player.set("position", Vector2(-35, 360))

func _on_end_dialogue(reference: String) -> void:
	if reference == "intro":
		$animation.play("intro_2")

func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()
		
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "intro_1":
		game.run_dialogue("intro", self)
	elif anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/"+ next_map + ".tscn")
	elif game.is_new_game and anim_name == "transition_in":
		$animation.play("intro_1")
	elif anim_name == "transition_in":
		add_child(hud)
		$ysort/player.play_animation("", false)
		
func _on_portal_laboratory_body_entered(_body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	next_map = "laboratory"

func _on_portal_forest_body_entered(_body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")
	game.change_music(load("res://audio/music/forest.ogg"))
	next_map = "forest"

