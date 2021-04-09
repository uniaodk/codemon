extends CanvasLayer

var is_main_scene: bool = true

func _process(_delta: float) -> void:
	if game.is_active_buff_capture and game.timer_buff_capture.is_stopped():
		if game.left_time_capture != 0:
			game.timer_buff_capture.start(game.left_time_capture)
		else:
			game.timer_buff_capture.start(game.duration_buff_capture)
	if game.is_active_buff_coin and game.timer_buff_coin.is_stopped():
		if game.left_time_coin != 0:
			game.timer_buff_coin.start(game.left_time_coin)
		else:
			game.timer_buff_coin.start(game.duration_buff_coin)
	update_hud()

func _ready() -> void:
	translation();
	add_child(game.timer_buff_capture)
	add_child(game.timer_buff_coin)
	game.timer_buff_capture.connect("timeout", self, "_on_timer_capture_timeout")
	game.timer_buff_coin.connect("timeout", self, "_on_timer_coin_timeout")

func translation() -> void:
	$button/gear.hint_tooltip = tr("OPTIONS") + " (ESC)";
	$button/codex.hint_tooltip = "Codex (C)";
	$button/scroll.hint_tooltip = tr("QUESTS") + " (Q)";
	$button/bag.hint_tooltip = tr("INVENTORY") + " (I)";
	$button/map.hint_tooltip = tr("MAP") + " (M)";
	$buff/coin.hint_tooltip = tr("BUFF_COIN_DESC");
	$buff/capture.hint_tooltip = tr("BUFF_CAPTURE_DESC");

func update_hud() -> void:
	$buff/capture.set_visible(!game.timer_buff_capture.is_stopped())
	$buff/capture_time.set_visible(!game.timer_buff_capture.is_stopped())
	$buff/coin.set_visible(!game.timer_buff_coin.is_stopped())
	$buff/coin_time.set_visible(!game.timer_buff_coin.is_stopped())
	$info/coin_qtd.set_text("%03d" % [game.coin])
	$info/control/battery.frame = 10 - game.energy
	$info/control.hint_tooltip = String(10 * game.energy) + "%"
	game.left_time_capture = game.timer_buff_capture.time_left
	game.left_time_coin = game.timer_buff_coin.time_left
	$buff/capture_time.set_text(get_time(game.timer_buff_capture.time_left))
	$buff/coin_time.set_text(get_time(game.timer_buff_coin.time_left))
	

func get_time(seconds: float) -> String:
	var minutes: int = seconds / 60
	var sec: int = int(seconds) % 60
	return "%02d:%02d" % [minutes, sec]
	

func _on_timer_coin_timeout() -> void:
	game.is_active_buff_coin = false
	game.left_time_coin = 0
	game.timer_buff_coin.stop()
	$buff/coin.set_visible(false)
	$buff/coin_time.set_visible(false)	


func _on_timer_capture_timeout() -> void:
	game.is_active_buff_capture = false
	game.left_time_capture = 0
	game.timer_buff_capture.stop()
	$buff/capture.set_visible(false)
	$buff/capture_time.set_visible(false)	


func _on_gear_pressed() -> void:
	var pause_menu: Control = load("res://scene/interface/pause_menu.tscn").instance()
	add_child(pause_menu)
	get_tree().paused = true


func _on_scroll_pressed() -> void:
	if is_main_scene:
		var mission: Control = load("res://scene/interface/mission.tscn").instance()
		add_child(mission)
		is_main_scene = false


func _on_bag_pressed() -> void:
	if is_main_scene:
		var inventary: Control = load("res://scene/interface/inventary.tscn").instance()
		add_child(inventary)
		is_main_scene = false


func _on_map_pressed() -> void:
	if is_main_scene:
		var map: Control = load("res://scene/interface/map.tscn").instance()
		add_child(map)
		is_main_scene = false


func _on_codex_pressed() -> void:
	if is_main_scene:
		var codex: Control = load("res://scene/interface/codex.tscn").instance()
		add_child(codex)
		is_main_scene = false

func _on_delay_timeout() -> void:
	is_main_scene = true
	
func _exit_tree() -> void:
	for child in get_children():
		if child.is_in_group("timer"):
			remove_child(child)
		
