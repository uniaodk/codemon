extends Control

export (String) var type = "no_battery"
export (String) var codemon_type1 = "int"
export (String) var codemon_type2 = "double"
export (String) var operator = "not_equal"

func _ready() -> void:
	$box/ok/btn_name.text = "Ok";
	$box/ok.grab_focus()
	match type:
		"no_battery":
			$box/hbox.visible = false
			$box/image.texture = load("res://art/hud/no_battery.png")
			$box/msg.text = tr("NO_BATTERY");
		"no_coin":
			$box/hbox.visible = false
			$box/image.texture = load("res://art/hud/no_coin.png")
			$box/msg.text = tr("NO_COIN");
		"no_type":
			rect_position = rect_position + Vector2(-10, -170)
			$box/image.visible = false
			$box/hbox.visible = true
			$box/msg.text = (tr("NO_TYPE") + String(codemon_type1.capitalize()) 
							+ " - " + String(codemon_type2.capitalize()))
			$box/hbox/type_1.texture = load("res://art/character/codemon/"+codemon_type1+".png")
			$box/hbox/operator.texture = load("res://art/character/codemon/"+ operator +".png")
			$box/hbox/type_2.texture = load("res://art/character/codemon/"+codemon_type2+".png")
		"no_infinite":
			rect_position = rect_position + Vector2(-10, -170)
			$box/image.visible = true
			$box/hbox.visible = false
			$box/image.texture = load("res://art/hud/no_infinite.png")
			$box/msg.text = tr("NO_INFINITE");
		"no_divide_zero":
			rect_position = rect_position + Vector2(-10, -170)
			$box/image.visible = true
			$box/hbox.visible = false
			$box/image.texture = load("res://art/hud/no_divide_zero.png")
			$box/msg.text = tr("NO_DIVIDE_ZERO");
		"no_expression":
			rect_position = rect_position + Vector2(-10, -170)
			$box/image.visible = false
			$box/hbox.visible = true
			$box/msg.text = (tr("NO_EXPRESSION") + String(codemon_type1.capitalize()) 
							+ " " + operator + " " + String(codemon_type2.capitalize()))
			$box/hbox/type_1.texture = load("res://art/character/codemon/"+codemon_type1+".png")
			$box/hbox/operator.texture = load("res://art/character/codemon/"+ operator +".png")
			$box/hbox/type_2.texture = load("res://art/character/codemon/"+codemon_type2+".png")

func _on_ok_pressed() -> void:
	get_tree().paused = false
	queue_free()
