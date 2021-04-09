extends Control

var buttons: Dictionary ={ "triangle" : [game.codemon_name.get(game.CODEMON_INT),
						game.codemon_name.get(game.CODEMON_DOUBLE),
						game.codemon_name.get(game.CODEMON_STRING),
						game.codemon_name.get(game.CODEMON_BOOL)],
						
						"square" : [game.codemon_name.get(game.CODEMON_PLUS),
						game.codemon_name.get(game.CODEMON_MINUS),
						game.codemon_name.get(game.CODEMON_MULTIPLY),
						game.codemon_name.get(game.CODEMON_DIVIDE),
						game.codemon_name.get(game.CODEMON_MODULE)],
						
						"circle" : [game.codemon_name.get(game.CODEMON_LESS),
						game.codemon_name.get(game.CODEMON_BIGGER),
						game.codemon_name.get(game.CODEMON_EQUAL),
						game.codemon_name.get(game.CODEMON_NOTT),
						game.codemon_name.get(game.CODEMON_ANDD),
						game.codemon_name.get(game.CODEMON_ORR)]}


export (String, "triangle", "square", "circle") var type
var btn_list: Resource = load("res://scene/component/btn_list.tscn")

func _ready() -> void:
	instance_buttons()

func instance_buttons() -> void:
	var codemons : Array = buttons.get(type)
	for codemon in codemons:
		var btn_list_instance: TextureButton = btn_list.instance()
		btn_list_instance.codemon = codemon
		$scroll_container/vbox.add_child(btn_list_instance)
