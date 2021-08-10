extends Control

func _ready():
	$language.text = tr("LANGUAGE");

func _on_pt_mouse_entered():
	$pt.modulate = Color("#709aff")

func _on_pt_mouse_exited():
	$pt.modulate = Color("#ffffff")

func _on_en_mouse_entered():
	$en.modulate = Color("#709aff")

func _on_en_mouse_exited():
	$en.modulate = Color("#ffffff")

func _on_en_pressed():
	set_language(game.ENG);

func _on_pt_pressed():
	set_language(game.PT)

func set_language(language: String) -> void:
	persistence.load_progress();
	game.language = language;
	persistence.save_progress()
	TranslationServer.set_locale(game.language);
	get_tree().change_scene("res://scene/interface/main_menu.tscn")
