extends Control

var codemon: String
var is_simulation: bool = false

func _ready() -> void:
	translation();
	play_click()
	$ok.grab_focus()
	if codemon != "bubble_sort" and !is_simulation:
		game.status_challenge[codemon] = game.get_limited_item(game.status_challenge[codemon], 1)
	persistence.save_progress()

func translation() -> void:
	$ok/btn_name.text = "Ok";
	$result.text = tr("INCORRECT");
	$msg.text = tr("INCORRECT_MSG");

func _on_ok_pressed() -> void:
	get_tree().paused = false
	get_parent().queue_free()
	
func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/fail.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
