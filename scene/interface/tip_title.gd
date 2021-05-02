extends Control

var variables: Array = ["int", "double", "string", "bool"]
var operators: Array = ["plus", "minus", "divide", "multiply", "modulo"]
var logics: Array = ["equal", "not_equal", "bigger", "less", "and", "or"]
var controls: Array = ["if", "else", "for", "while"]
var bubble: String = "bubble_sort"

var content_variable: Dictionary = {"type": tr("VARIABLE"), "map": tr("F_VARIABLES")}
var content_operator: Dictionary = {"type": tr("ARITHMETIC"), "map": tr("M_OPERATORS")}
var content_logic: Dictionary = {"type": tr("LOGIC"), "map": tr("B_CONDITIONS")}
var content_control: Dictionary = {"type": tr("CONTROL"), "map": tr("C_CONTROLS")}
var content_bubble: Dictionary = {"type": tr("SORT"), "map": tr("BOSS")}
var content_circuit: Dictionary = {"type": tr("LOGIC_GATE"), "map": tr("ALL_MAPS")}

export (String) var codemon = ""

func _ready() -> void:
	translation();
	$hbox/codemon/value.text = tr(codemon.replace("_", " ").to_upper());
	$image.texture = load("res://art/character/codemon/"+ codemon +".png")
	if variables.has(codemon):
		$hbox/type/value.text = content_variable.get("type")
		$hbox/map/value.text = content_variable.get("map")
	elif operators.has(codemon):
		$hbox/type/value.text = content_operator.get("type")
		$hbox/map/value.text = content_operator.get("map")
	elif logics.has(codemon):
		$hbox/type/value.text = content_logic.get("type")
		$hbox/map/value.text = content_logic.get("map")
	elif controls.has(codemon):
		$hbox/type/value.text = content_control.get("type")
		$hbox/map/value.text = content_control.get("map")
	elif codemon == bubble:
		$hbox/type/value.text = content_bubble.get("type")
		$hbox/map/value.text = content_bubble.get("map")
	else:
		$hbox/type/value.text = content_circuit.get("type")
		$hbox/map/value.text = content_circuit.get("map")

func translation() -> void:
	$hbox/type.text = tr("TYPE") + ":";
	$hbox/map.text = tr("LOCATION") + ":";
