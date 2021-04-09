extends Control

func _ready() -> void:
	translation();
	$box/vbox_container/resume.grab_focus()

func translation() -> void:
	$box/paused.text = tr("PAUSE");
	$box/vbox_container/resume/btn_name.text = tr("RESUME");
	$box/vbox_container/option/btn_name.text = tr("OPTIONS");
	$box/vbox_container/main_menu/btn_name.text = tr("MAIN_MENU");
	$box_confirm/question.text = tr("QUIT_MSG");
	$box_confirm/obs.text = tr("QUIT_OBS");
	$box_confirm/hbox_container/yes/btn_name.text = tr("YES");
	$box_confirm/hbox_container/no/btn_name.text = tr("NO");

func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_option_pressed() -> void:
	var option : Control= load("res://scene/interface/option_menu.tscn").instance()
	add_child(option)
	get_tree().paused = true

func _on_main_menu_pressed() -> void:
	$box_confirm.set_visible(true)

func _on_yes_box_confirm_pressed() -> void:
	game.change_music(load("res://audio/music/boss_defeated.ogg"))
	persistence.save_progress()
	$tween.interpolate_property(game.get_last_child_root(), "modulate:a8", 255, 0, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.hide()
	$tween.start()

func _on_no_box_confirm_pressed() -> void:
	$box_confirm.set_visible(false)

func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	get_tree().paused = false
	get_tree().change_scene("res://scene/interface/main_menu.tscn")
