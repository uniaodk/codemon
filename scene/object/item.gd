extends Control

signal doubleclick()

onready var hint: Dictionary = {
	"pen_capture": tr("GREEN_PEN_DRIVE") + "\n" + tr("BUFF_CAPTURE_DESC"),
	"pen_coin": tr("GOLD_PEN_DRIVE") + "\n" + tr("BUFF_COIN_DESC"),
	"battery": tr("PORTABLE_BATTERY") + "\n" + tr("BATTERY_DESC"),
};

func _ready() -> void:
	translation();
	connect("doubleclick", get_parent().get_parent(), "_on_consume_" + self.name)
	
func translation() -> void:
	hint_tooltip = hint.get(name);
 
func _on_gui_input(event: InputEvent) -> void:
	if ((event is InputEventMouseButton and event.doubleclick) 
			or event.is_action_pressed("ui_accept")):
		emit_signal("doubleclick")
