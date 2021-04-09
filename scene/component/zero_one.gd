extends TextureButton

var is_zero: bool = true

func _on_zero_one_button_down() -> void:
	play_click()
	if is_zero:
		set_normal_texture(load("res://art/chalenge/circuit_logic/one.png"))
		set_pressed_texture(load("res://art/chalenge/circuit_logic/zero_selected.png"))
		set_hover_texture(load("res://art/chalenge/circuit_logic/one_selected.png"))
	else:
		set_normal_texture(load("res://art/chalenge/circuit_logic/zero.png"))
		set_pressed_texture(load("res://art/chalenge/circuit_logic/one_selected.png"))
		set_hover_texture(load("res://art/chalenge/circuit_logic/zero_selected.png"))
	is_zero = !is_zero

func reset() -> void:
	if !is_zero:
		_on_zero_one_button_down()

func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/button.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
