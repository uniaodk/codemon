extends Control

var codemon: String = '0'
var rollete: String
var is_capture: bool = false 
var gain_coin: int = 0
var is_tutorial: bool = false
var is_simulation: bool = false

func _ready() -> void:
	translation();
	play_click()
	calculate_chance_capture()
	calculate_gain_coin()
	init_scene()
	config_animation()
	config_visibility_buff()
	$ok.grab_focus()
	$animation.play("splash_capture")

func translation() -> void:
	$result.text = tr("CORRECT");
	$title_capture.text = tr("CAPTURE"); 
	$ok/btn_name.text = "Ok";

func set_result_captured() -> void:
	$result_capture.text = tr("CAPTURED");
	
func set_result_fled() -> void:
	$result_capture.text = tr("FLED");

func init_scene() -> void:
	$codemon.texture = load("res://art/character/codemon/" 
							+ game.codemon_name.get(codemon) + ".png")
	$bonus_capture/normal.text = ("%2d" % (game.capture_codemon.get(codemon) * 100)) + "%"
	$bonus_coin/normal.text = "%1d" % game.coin_codemon.get(codemon)
	

func calculate_chance_capture() -> void:
	var chance: float = game.capture_codemon.get(codemon) 
	chance = chance + 0.2 if game.is_active_buff_capture else chance 
	chance = chance + 0.2 if game.mission_operator else  chance
	chance = chance + 0.2 if game.mission_logic else chance
	randomize()
	is_capture = chance >= randf()


func calculate_gain_coin() -> void:
	gain_coin = game.coin_codemon.get(codemon)
	gain_coin = gain_coin * 2 if game.is_active_buff_coin else gain_coin
	gain_coin = gain_coin * 2 if game.misson_variable else gain_coin
	

func config_animation() -> void:
	rollete = "rollete_sucess" if is_capture else "rollete_fail"
	$animation.animation_set_next("splash_capture", "splash_buff_capture")
	$animation.animation_set_next("splash_buff_capture", "splash_operator_capture")
	$animation.animation_set_next("splash_operator_capture", "splash_logic_capture")
	$animation.animation_set_next("splash_logic_capture", rollete)
	$animation.animation_set_next(rollete, "splash_coin")
	$animation.animation_set_next("splash_coin", "splash_buff_coin")
	$animation.animation_set_next("splash_buff_coin", "splash_variable_coin")
	$animation.animation_set_next("splash_variable_coin", "splash_gain_coin")

	
func config_visibility_buff() -> void:
	$bonus_capture/buff.visible = game.is_active_buff_capture
	$bonus_capture/operator.visible = game.mission_operator
	$bonus_capture/logic.visible = game.mission_logic
	$bonus_coin/buff.visible = game.is_active_buff_coin
	$bonus_coin/variable.visible = game.misson_variable	


func update_status() -> void:
	if !is_tutorial and !is_simulation:
		if is_capture:
			game.status_capture[codemon] = game.get_limited_item(game.status_capture[codemon], 1)
		game.coin = game.get_limited_gold(game.coin, gain_coin)
		game.status_challenge[codemon] = game.get_limited_item(game.status_challenge[codemon], 1)
		game.check_missions()
	persistence.save_progress()


func _on_ok_pressed() -> void:
	update_status()
	get_tree().paused = false
	get_parent().queue_free()
	

func set_gain_gold(gold: int) -> void:
	$result_coin.text = String(gold)


func _on_animation_finished(anim_name: String) -> void:
	$tween.interpolate_method(self, "set_gain_gold",
		0, gain_coin, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/success.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)
