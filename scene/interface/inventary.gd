extends Control

var pen_coin: Control = load("res://scene/object/pen_coin.tscn").instance()
var pen_capture: Control = load("res://scene/object/pen_capture.tscn").instance()
var battery: Control = load("res://scene/object/battery.tscn").instance()

func _ready() -> void:
	translation();
	update_grid()
	
func translation() -> void:
	$title.text = tr("INVENTORY");
	$button/btn_name.text = tr("BACK");

func update_grid() -> void:
	update_battery()
	update_pen_capture()
	update_pen_coin()
	update_focus()

func update_focus() -> void:
	if $grid.get_child_count() > 0:
		$grid.get_child(0).grab_focus()
	else:
		$button.grab_focus()


func update_battery() -> void:
	if game.battery != 0:
		battery.get_node("qtd").text = "%02d" % game.battery
		if !$grid.is_a_parent_of(battery):
			$grid.add_child(battery)

func update_pen_coin() -> void:
	if game.pen_coin != 0:
		pen_coin.get_node("qtd").text = "%02d" % game.pen_coin
		if !$grid.is_a_parent_of(pen_coin):
			$grid.add_child(pen_coin)
	

func update_pen_capture() -> void:
	if game.pen_capture != 0:
		pen_capture.get_node("qtd").text = "%02d" % game.pen_capture
		if !$grid.is_a_parent_of(pen_capture):
			$grid.add_child(pen_capture)


func remove_from_grid(item: Control, condition: bool) -> void:
	if condition:
		$grid.remove_child(item)
		update_focus()


func _on_consume_pen_capture() -> void:
	game.is_active_buff_capture = true
	game.add_timer_buff_capture()
	game.pen_capture = game.pen_capture - 1 if game.pen_capture > 0 else 0
	remove_from_grid(pen_capture, game.pen_capture == 0)
	update_pen_capture()
	
	
func _on_consume_pen_coin() -> void:
	game.is_active_buff_coin = true
	game.add_timer_buff_coin()
	game.pen_coin = game.pen_coin - 1 if game.pen_coin > 0 else 0
	remove_from_grid(pen_coin, game.pen_coin == 0)
	update_pen_coin()

	
func _on_consume_battery() -> void:
	game.energy = game.energy + 5 if game.energy + 5 <= 10  else 10
	game.battery = game.battery - 1 if game.battery > 0 else 0
	remove_from_grid(battery, game.battery == 0)
	update_battery()


func _on_button_pressed() -> void:
	get_parent().get_node("delay").start(0.2)
	queue_free()
