extends Control

export (String, "triangle", "square", "circle") var type

var list: Resource = load("res://scene/component/list_codemon.tscn")

signal set_text()
signal codemon_selected()

var is_picked: bool = false
var value: String = ""
var codemon_selected: String = ""

func _ready() -> void:
	connections()

func reset() -> void:
	is_picked = false
	value = ""
	codemon_selected = ""
	$label/text.text = ""
	$btn/sprite.texture = null

func connections() -> void:
	$btn.connect("pressed", self, "update_texture")
	$btn.connect("pressed", self, "show_list")
	$label.connect("pressed", self, "edit_text")
	$label/text.connect("focus_entered", self, "on_focus_entered_text")
	$label/text.connect("text_entered", self, "input_value")
	$label/text.connect("focus_exited", self, "on_focus_exited_text")
	connect("set_text", get_parent(), "check_filled_btn")
	
func on_focus_entered_text() -> void:
	if type != "triangle":
		$label/text.release_focus()
	
func on_focus_exited_text() -> void:
	if !codemon_selected.empty():
		value = validation_entrie($label/text.text)
		$label/text.text = value
		emit_signal("set_text")

func validation_entrie(text: String) -> String:
	if codemon_selected == "int" and !text.is_valid_integer():
		return "1"
	elif codemon_selected == "double":
		if !text.is_valid_float():
			return "1.5"
		else:
			if !text.match("*.*"):
				var size: int = text.length() - 1 if text.length() == 5 else text.length()
				return "%.1f" % stepify(float(text.substr(0, size) + "e-1"), 0.1)
			else:
				return "%.1f" % stepify(float(text), 0.1)
	elif codemon_selected == "bool" and !(text == "false" or text == "true"):
		return "true"
	return "aBcD3" if text.empty() else text


func update_texture() -> void:
	play_click()
	if !is_picked:
		udpate_texture_pressed()


func input_value(text: String) -> void:
	value = validation_entrie(text)
	$label/text.text = value
	$label/text.editable = false
	$label.grab_focus()
	emit_signal("set_text")


func edit_text() -> void:
	play_click()
	$label/text.editable = true
	$label/text.text = ""
	$label/text.grab_focus()


func udpate_texture_pressed() -> void:
	$btn.texture_normal = load("res://art/chalenge/analyze_algorithm/btn_codemon_pressed_normal.png")
	$btn.texture_hover = load("res://art/chalenge/analyze_algorithm/btn_codemon_pressed_hover.png")


func show_list() -> void:
	play_click()
	var list_instance: Control = list.instance()
	list_instance.type = type
	if !get_child(get_child_count() -1).name == "list_codemon":
		add_child(list_instance)


func on_codemon_selected(codemon: String) -> void:
	codemon_selected = codemon
	$label.disabled = false
	$label.grab_click_focus()
	$btn/sprite.texture = load("res://art/character/codemon/"+ codemon +".png")
	edit_text()
	emit_signal("codemon_selected")

func set_type(new_type: String) -> void:
	type = new_type
	$label.visible = type == "triangle"

func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/button.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
