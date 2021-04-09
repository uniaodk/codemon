extends TextureButton

var is_checked: bool  = false

func _ready() -> void:
	set_texture()

func set_texture() -> void:
	if is_checked:
		set_normal_texture(load("res://art/component/check_box_normal_checked.png"))
		set_pressed_texture(load("res://art/component/check_box_selected.png"))
		set_hover_texture(load("res://art/component/check_box_selected_checked.png"))
	else:
		set_normal_texture(load("res://art/component/check_box_normal.png"))
		set_pressed_texture(load("res://art/component/check_box_selected_checked.png"))
		set_hover_texture(load("res://art/component/check_box_selected.png"))

func _on_check_box_pressed() -> void:
	play_click()
	set_texture()
	is_checked = !is_checked

func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/button.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
