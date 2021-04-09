extends TextureButton

export (String, 'a', 'b', 'c') var letter
var is_marked: bool = false

func _ready() -> void:
	set_texture()

func _on_btn_question_down() -> void:
	play_click()
	is_marked = !is_marked
	set_texture()

func set_texture() -> void:
	if is_marked:
		set_normal_texture(load("res://art/chalenge/question/option_" + letter + "_pressed_normal.png"))
		set_pressed_texture(load("res://art/chalenge/question/option_"+ letter +"_selected.png"))
		set_hover_texture(load("res://art/chalenge/question/option_"+ letter +"_pressed_selected.png"))
	else:
		set_normal_texture(load("res://art/chalenge/question/option_" + letter + "_normal.png"))
		set_pressed_texture(load("res://art/chalenge/question/option_"+ letter +"_pressed_selected.png"))
		set_hover_texture(load("res://art/chalenge/question/option_"+ letter +"_selected.png"))

func update_button(condition: bool) -> void:
	is_marked = condition
	set_texture()


func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/button.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
