extends Control

var option_menu : Resource = preload("res://scene/interface/option_menu.tscn")
var simulator_rs: Resource = load("res://scene/chalenge/simulator.tscn")

var maps: Dictionary = {
	game.MAP_STREET: "street",
	game.MAP_LAB: "laboratory",
	game.MAP_FOREST: "forest",
	game.MAP_MOUNTAIN: "mountain",
	game.MAP_BEACH: "beach",
	game.MAP_DESERT: "desert",
	game.MAP_BOSS: "boss"
}

var music: Dictionary = {
	game.MAP_STREET: load("res://audio/music/street_laboratory.ogg"),
	game.MAP_LAB: load("res://audio/music/street_laboratory.ogg"),
	game.MAP_FOREST: load("res://audio/music/forest.ogg"),
	game.MAP_MOUNTAIN: load("res://audio/music/mountain.ogg"),
	game.MAP_BEACH: load("res://audio/music/beach.ogg"),
	game.MAP_DESERT: load("res://audio/music/desert.ogg"),
	game.MAP_BOSS: [load("res://audio/music/boss.ogg"), load("res://audio/music/boss_defeated.ogg")]
}

func _ready() -> void:
	translation();
	$background/vbox_container/continue.set_disabled(game.is_new_game)
	$background/vbox_container/simulator.set_disabled(!game.is_finished_game)
	$background/vbox_container/new_game.grab_focus()
	$background/version.text = "version_" + ProjectSettings.get("application/config/version")

func translation() -> void:
	$background/vbox_container/new_game/btn_name.text = tr("NEW_GAME");
	$background/vbox_container/continue/btn_name.text = tr("CONTINUE");
	$background/vbox_container/simulator/btn_name.text = tr("SIMULATOR");
	$background/vbox_container/simulator.hint_tooltip = tr("SIMULATOR_HINT");
	$background/vbox_container/option/btn_name.text = tr("OPTIONS");
	$background/vbox_container/exit/btn_name.text = tr("EXIT");
	

func _on_option_pressed() -> void:
	var option: Control= option_menu.instance()
	get_parent().add_child(option)
	get_tree().paused = true
	
func _on_new_game_pressed() -> void:
	game.reset_config()
	persistence.save_progress()
	game.change_music(get_music())
	$animation.play("transition")

func _on_animation_finished(_anim_name) -> void:
	get_tree().change_scene("res://scene/map/" + maps.get(game.current_map) + ".tscn")

func _on_continue_pressed() -> void:
	game.change_music(get_music())
	$animation.play("transition")


func _on_simulator_pressed() -> void:
	var simulator: Control= simulator_rs.instance()
	get_parent().add_child(simulator)
	get_tree().paused = true

func get_music() -> Resource:
	if game.current_map == 6:
		return music.get(game.current_map)[int(game.is_finished_game)]
	else:
		return music.get(game.current_map)

func _on_exit_pressed():
	get_tree().quit();
