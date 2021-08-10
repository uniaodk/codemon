extends Control

var buy_coin: int = 0
var buy_capture: int = 0
var buy_battery: int = 0

onready var coin: Control = load("res://scene/object/pen_coin.tscn").instance()
onready var capture: Control = load("res://scene/object/pen_capture.tscn").instance()
onready var battery: Control = load("res://scene/object/battery.tscn").instance()

onready var warning: Resource = load("res://scene/interface/warnig.tscn")

func _ready() -> void:
	translate();
	$coin/price.grab_focus()

func translate() -> void:
	$market.text = tr("STORE");
	$bag.text = tr("CART");
	$battery/desc3.text = tr("BUFF_CAPTURE_DESC");
	$battery/name.text = tr("PORTABLE_BATTERY");
	$battery/price/btn_name.text = "15";
	$capture/desc2.text = tr("BATTERY_DESC");
	$capture/name.text = tr("GREEN_PEN_DRIVE");
	$capture/price/btn_name.text = "30";
	$coin/desc.text = tr("BUFF_COIN_DESC");
	$coin/name.text = tr("GOLD_PEN_DRIVE");
	$coin/price/btn_name.text = "50";
	$back/btn_name.text = tr("BACK");
	$buy/btn_name.text = tr("BUY");
	$warning.text = tr("OBS_STORE");

func calculate_total() -> void:
	var total: int = (buy_coin * int($coin/price/btn_name.text)
					+ buy_capture * int($capture/price/btn_name.text)
					+ buy_battery * int($battery/price/btn_name.text))
	$total/value.text = "%03d" % total


func _on_battery_price_pressed() -> void:
	if !pass_limit(int($battery/price/btn_name.text)):
		buy_battery = buy_battery + 1
		battery.get_node("qtd").text = "%02d" % buy_battery
		if !$grid.is_a_parent_of(battery):
			$grid.add_child(battery, true)
		calculate_total()

func _on_capture_price_pressed() -> void:
	if !pass_limit(int($capture/price/btn_name.text)):
		buy_capture = buy_capture + 1
		capture.get_node("qtd").text = "%02d" % buy_capture
		if !$grid.is_a_parent_of(capture):
			$grid.add_child(capture, true)
		calculate_total()


func _on_coin_price_pressed() -> void:
	if !pass_limit(int($coin/price/btn_name.text)):
		buy_coin = buy_coin + 1
		coin.get_node("qtd").text = "%02d" % buy_coin
		if !$grid.is_a_parent_of(coin):
			$grid.add_child(coin, true)
		calculate_total()
	
func pass_limit(price_item: int) -> bool:
	return int($total/value.text) + price_item > game.MAX_COIN


func remove_from_grid(item: Control, condition: bool) -> void:
	if condition:
		$grid.remove_child(item)

func _on_consume_battery() -> void:
	buy_battery = buy_battery - 1
	battery.get_node("qtd").text = "%02d" % buy_battery
	remove_from_grid(battery, buy_battery == 0)
	calculate_total()
	

func _on_consume_pen_coin() -> void:
	buy_coin = buy_coin - 1
	coin.get_node("qtd").text = "%02d" % buy_coin
	remove_from_grid(coin, buy_coin == 0)
	calculate_total()
	
	
func _on_consume_pen_capture() -> void:
	buy_capture = buy_capture - 1
	capture.get_node("qtd").text = "%02d" % buy_capture
	remove_from_grid(capture, buy_capture == 0)
	calculate_total()


func _on_buy_pressed() -> void:
	if game.coin >= int($total/value.text):
		game.coin = game.coin - int($total/value.text)
		game.battery = game.get_limited_item(game.battery, buy_battery)
		game.pen_coin = game.get_limited_item(game.pen_coin, buy_coin)
		game.pen_capture = game.get_limited_item(game.pen_capture, buy_capture)
		_on_back_pressed()
	else:
		var warning_scene = warning.instance()
		warning_scene.type = "no_coin"
		get_parent().add_child(warning_scene)


func _on_back_pressed() -> void:
	get_tree().paused = false
	queue_free()

