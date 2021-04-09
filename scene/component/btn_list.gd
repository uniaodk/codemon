extends TextureButton

export (String) var codemon
signal codemon_selected(codemon)

func _ready() -> void:
	connect("pressed", self, "on_btn_pressed")
	$codemon.texture = load("res://art/character/codemon/"+ codemon +".png")
	$codemon_name.text = codemon.capitalize()

func on_btn_pressed() -> void:
	connect("codemon_selected", get_parent().get_parent().get_parent().get_parent(),"on_codemon_selected")
	get_parent().get_parent().get_parent().queue_free()
	emit_signal("codemon_selected", codemon)
	
