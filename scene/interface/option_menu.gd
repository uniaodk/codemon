extends Control

onready var volume_music : int = game.volume_music
onready var volume_effect : int =  game.volume_effect
onready var is_muted_music : bool = game.is_muted_music
onready var is_muted_effect : bool = game.is_muted_effect
onready var language: String = game.language

const MUTED : int = 5

func _ready() -> void:
	translation();
	$music/decrease.grab_focus()
	$music/mute.is_checked = is_muted_music
	$music/mute._on_check_box_pressed()
	config_music()
	$effect/mute.is_checked = is_muted_effect
	$effect/mute._on_check_box_pressed()
	config_effect()
	
func translation() -> void:
	$title.text = tr("OPTIONS");
	$music.text = tr("MUSIC");
	$music/lab_mute.text = tr("MUTE");
	$effect.text = tr("EFFECT");
	$effect/lab_mute.text = tr("MUTE");
	$hbox_container/save/btn_name.text = tr("SAVE");
	$hbox_container/back/btn_name.text = tr("BACK");

func config_music() -> void:
	$music/volume.frame = MUTED if is_muted_music else volume_music
	var index : int = AudioServer.get_bus_index($music.name)
	AudioServer.set_bus_volume_db(index, 4 - 6 * volume_music)
	AudioServer.set_bus_mute(index, is_muted_music)

func config_effect() -> void:
	$effect/volume.frame = MUTED if is_muted_effect else volume_effect
	var index : int = AudioServer.get_bus_index($effect.name)
	AudioServer.set_bus_volume_db(index, 4 - 6 * volume_effect)
	AudioServer.set_bus_mute(index, is_muted_effect)

func _on_back_pressed() -> void:
	get_tree().paused = false
	restore_variable()
	config_effect()
	config_music()
	self.queue_free()

func _on_save_pressed() -> void:
	save_variable()
	get_tree().paused = false
	self.queue_free()

func save_variable() -> void:
	game.volume_music = volume_music
	game.volume_effect = volume_effect
	game.is_muted_music = is_muted_music
	game.is_muted_effect = is_muted_effect

func restore_variable() -> void:
	volume_music = game.volume_music
	volume_effect =  game.volume_effect
	is_muted_music = game.is_muted_music
	is_muted_effect = game.is_muted_effect

func _on_decrease_effect_pressed() -> void:
	volume_effect = volume_effect + 1 if volume_effect < MUTED else MUTED
	if volume_effect == MUTED and !is_muted_effect:
		volume_effect = volume_effect - 1
		$effect/mute._on_check_box_pressed()
		_on_mute_effect_pressed()
	else:
		config_effect()

func _on_increase_effect_pressed() -> void:
	if is_muted_effect:
		$effect/mute._on_check_box_pressed()
		_on_mute_effect_pressed()
	else:
		volume_effect = volume_effect - 1 if volume_effect > 0 else 0
		config_effect()

func _on_mute_effect_pressed() -> void:
	is_muted_effect = !is_muted_effect
	volume_effect = volume_effect - 1 if volume_effect == MUTED else volume_effect
	config_effect()

func _on_decrease_music_pressed() -> void:
	volume_music = volume_music + 1 if volume_music < MUTED else MUTED
	if volume_music == MUTED and !is_muted_music:
		volume_music = volume_music - 1
		$music/mute._on_check_box_pressed()
		_on_mute_music_pressed()
	else:
		config_music()

func _on_increase_music_pressed() -> void:
	if is_muted_music:
		$music/mute._on_check_box_pressed()
		_on_mute_music_pressed()
	else:
		volume_music = volume_music - 1 if volume_music > 0 else 0
		config_music()

func _on_mute_music_pressed() -> void:
	is_muted_music = !is_muted_music
	volume_music = volume_music - 1 if volume_music == MUTED else volume_music
	config_music()
