extends Control

func _on_animation_animation_finished(_anim_name) -> void:
	TranslationServer.set_locale(game.language);
	get_tree().change_scene("res://scene/interface/language.tscn")
