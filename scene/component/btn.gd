extends TextureButton

var is_toggle: bool = false

func _ready() -> void:
	if disabled:
		$btn_name.set("custom_colors/font_color", Color("646464"))

func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/button.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)

func _on_circle_button_down() -> void:
	$animation.play("clicked")
	play_click()

func _on_circle_button_up() -> void:
	$animation.play("normal")

func _on_button_down() -> void:
	play_click()
	$animation.play("clicked")

func _on_button_up() -> void:
	$animation.play("normal")

func _on_button_toggle_down() -> void:
	is_toggle = !is_toggle
	if is_toggle:
		play_click()
		$animation.play("clicked")
	else:
		$animation.play("normal")
		
func set_toggle(_is_toggle: bool) -> void:
	is_toggle = _is_toggle
	set_pressed(is_toggle)
	if is_toggle:
		play_click()
		$animation.play("clicked")
	else:
		$animation.play("normal")

func set_disabled(condition: bool) -> void:
	disabled = condition
	if condition:
		$btn_name.set("custom_colors/font_color", Color("646464"))
	else:
		$btn_name.set("custom_colors/font_color", Color("000000"))
