extends Control

signal end_dialogue(reference)
onready var hud: CanvasLayer = load("res://scene/interface/hud.tscn").instance()


func _ready() -> void:
	config_position_player()
	check_is_new_game()
	init_map()
	connect("end_dialogue", self, "_on_end_dialogue")
	game.current_map = game.MAP_LAB

func config_position_player() -> void:
	if game.current_map == game.MAP_STREET:
		$ysort/player.play_animation("idle_up", true)
		$ysort/player.set("position", Vector2(514, 489))

func init_map() -> void:
	$tilemap.modulate.a8 = 0
	$ysort.modulate.a8 = 0
	$animation.play("transition_in")


func check_is_new_game():
	if !game.is_new_game:
		$tilemap/portal_street.set_visible(true)
		$tilemap/portal_street.set_monitoring(true)
	if game.did_get_notebook:
		$ysort/notebook.queue_free()
		
		
func _on_portal_street_body_entered(_body: Node) -> void:
	$ysort/player.play_animation("", true)
	$animation.play("transition_out")


func _on_end_dialogue(reference: String) -> void:
	$ysort/player.play_animation("", false)
	game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))
	if reference == "laboratory_part_1":
		$ysort/player.play_animation("idle_left", false)	
	elif reference == "laboratory_tutorial":
		game.is_new_game = false
		$tilemap/portal_street.set_visible(true)
		$tilemap/portal_street.set_monitoring(true)
	
	
func _on_dr_compilador_chat_entered() -> void:
	if !$animation.is_playing():
		game.add_interaction_btn($ysort/player, tr("TALK"), tr("DR"))


func _on_dr_compilador_chat_exited() -> void:
	game.get_last_child_add($ysort/player).queue_free()


func _on_notebook_pickup_entered() -> void:
	game.add_interaction_btn($ysort/player, tr("PICK"), "Notebook")


func _on_notebook_pickup_exited() -> void:
	game.get_last_child_add($ysort/player).queue_free()


func _on_pick_talk_interaction(object: String) -> void:
	if object == tr("DR"):
		game.get_last_child_add($ysort/player).queue_free()
		$ysort/player.play_animation("", true)
		game.run_dialogue("laboratory_part_2", self)
	elif object == "Notebook":
		add_child(hud)
		game.did_get_notebook = true
		$ysort/notebook.queue_free()


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "transition_out":
		hud.queue_free()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "transition_out":
		get_tree().change_scene("res://scene/map/street.tscn")
	elif anim_name == "intro" :
		$ysort/player.play_animation("", true)
		game.run_dialogue("laboratory_part_1", self)
	elif game.is_new_game and anim_name == "transition_in":
		$animation.play("intro")
	else:
		add_child(hud)
		$ysort/player.play_animation("", false)
