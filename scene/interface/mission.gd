extends Control

onready var amount_variable = game.get_amount_variable()
onready var amount_operator = game.get_amount_operator()
onready var amount_logic = game.get_amount_logic()
onready var amount_control = game.get_amount_control()

func _ready() -> void:
	translation();
	$back.grab_focus()
	config_mission($hbox_icon/variable_mission, $hbox_objetive/variable, 
					$hbox_buff/variable, amount_variable)
	config_mission($hbox_icon/operator_mission, $hbox_objetive/operator, 
					$hbox_buff/operator, amount_operator)
	config_mission($hbox_icon/logic_mission, $hbox_objetive/logic,
					$hbox_buff/logic, amount_logic)
	config_mission($hbox_icon/control_mission, $hbox_objetive/control, 
					$hbox_buff/control, amount_control)

func translation() -> void :
	$title.text = tr("QUESTS");
	$description.text = tr("DESC_QUEST");
	$hbox_type/variable.text = tr("VARIABLES");
	$hbox_type/operator.text = tr("ARITHMETIC_OP");
	$hbox_type/logic.text = tr("LOGIC_OP");
	$hbox_type/control.text = tr("CONTROL_FLOW");
	$hbox_icon/variable_mission.hint_tooltip = tr("VAR_HINT");
	$hbox_icon/operator_mission.hint_tooltip = tr("ARITH_HINT");
	$hbox_icon/logic_mission.hint_tooltip = tr("LOGIC_HINT");
	$hbox_icon/control_mission.hint_tooltip = tr("CONTROL_HINT");
	$hbox_buff/variable.text = tr("BONUS_COIN");
	$hbox_buff/operator.text = tr("BONUS_CAPTURE");
	$hbox_buff/logic.text = tr("BONUS_CAPTURE");
	$hbox_buff/control.text = tr("INFINITE_ENERGY");
	$back/btn_name.text = tr("BACK");

func config_mission(image: TextureRect, objetive: Label, 
					buff: Label, amount: int) -> void:
	if amount < 20:
		objetive.text = "%02d" % [amount] + " / 20"
		buff.set("custom_colors/font_color", Color(Color.gray))
		image.material.shader = load("res://grayscale.shader")
	else:
		objetive.text = "20 / 20"


func _on_back_pressed() -> void:
	get_parent().get_node("delay").start(0.2)
	queue_free()
