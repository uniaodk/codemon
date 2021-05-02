extends Control

onready var success: Control = load("res://scene/interface/feedback_ok.tscn").instance()
onready var fail: Control = load("res://scene/interface/feedback_fail.tscn").instance()
onready var warning: Control = load("res://scene/interface/warnig.tscn").instance()
onready var help: Resource = load("res://scene/interface/help.tscn")

onready var value_a : Dictionary = { "type" : null,
						"value" : null}
						
onready var value_b : Dictionary = { "type" : null,
						"value" : null}

onready var value_c : Dictionary = { "type" : null,
						"value" : null}

onready var value_d : Dictionary = { "type" : null,
						"value" : null}

onready var values: Dictionary = { "a" : value_a,
							"b" : value_b,
							"c" : value_c,
							"d" : value_d}

export (String) var codemon_chalenged
export (int) var number_question = -1
var is_simulation: bool = false

var question: Dictionary
var shapes_type: Array
var assigns_type: Array
var assigns: Array	
var expressions: Array
var variables: Array
var waited: String
var return_value: String = ""

var codemons: Dictionary = { "plus" : "res://scene/character/codemons/plus.tscn", 
							"minus" : "res://scene/character/codemons/minus.tscn",
							"multiply" : "res://scene/character/codemons/multiply.tscn",
							"divide" : "res://scene/character/codemons/divide.tscn",
							"modulo" : "res://scene/character/codemons/modulo.tscn",
							"less" :  "res://scene/character/codemons/less.tscn",
							"bigger" : "res://scene/character/codemons/bigger.tscn",
							"equal" :  "res://scene/character/codemons/equal.tscn",
							"not_equal" : "res://scene/character/codemons/not_equal.tscn",
							"and" : "res://scene/character/codemons/andd.tscn",
							"or" : "res://scene/character/codemons/orr.tscn",
							"if" : "res://scene/character/codemons/iff.tscn",
							"else" : "res://scene/character/codemons/elsee.tscn",
							"for" : "res://scene/character/codemons/forr.tscn",
							"while" : "res://scene/character/codemons/whilee.tscn"}

var symbols: Dictionary = { "plus" : "+", 
							"minus" : "-",
							"multiply" : "*",
							"divide" : "/",
							"modulo" : "%",
							"less" :  "<",
							"bigger" : ">",
							"equal" :  "==",
							"not_equal" : "!=",
							"and" : "and",
							"or" : "or"}
							
var gambi: Dictionary = { "+" : "plus", 
							"-" : "minus",
							"*" : "multiply",
							"/" : "divide",
							"%" : "modulo",
							"<" :  "less",
							">" : "bigger",
							"==" :  "equal",
							"!=" : "not_equal",
							"and" : "and",
							"or" : "or"}

var variables_code: Dictionary = { 	1 : "bool",
									2 : "int",
									3 : "double",
									4 : "string"}

func _ready() -> void:
	init_translation();
	init_variables()
	update_level()
	update_sprite()
	init_connections()
	init_components()
	draw_expression()

func init_translation() -> void:
	$title.text = tr("STAGE_2_TITLE");
	$question.text = tr("STAGE_2_DESC");
	$function/title.text = tr("FUNCTION");
	$function/waited.text = tr("EXPECTED");
	$function/result.text = tr("RESULT");
	$hint/title.text = tr("REMINDER");
	$hint/variable.text = tr("VARIABLES");
	$hint/arithmetic.text = tr("ARITHMETIC_OP2");
	$hint/logic.text = tr("LOGIC_OP2");
	$capture/btn_name.text = tr("CAPTURE");
	$flee/btn_name.text = tr("FLEE");
	$help/btn_name.text = tr("HELP");
	$debuger/btn_name.text = tr("DEBUG");


func result_chalenge() -> void:
	if (values.get(question.get("return")).get("type") == "double" 
			and step_decimals(float(return_value)) == 0):
		return_value = return_value + ".0"
	$function/value_result.text = return_value
	if return_value == waited:
		$function/bg.color = Color("ccffcc")
		yield(get_tree().create_timer(2.0), "timeout")
		success.codemon = game.codemon_name.values().find(codemon_chalenged)
		success.is_simulation = is_simulation
		add_child(success)
	else:
		$function/bg.color = Color("ffcccc")
		yield(get_tree().create_timer(2.0), "timeout")
		if !is_simulation:
			game.subtract_energy()
		fail.codemon = game.codemon_name.values().find(codemon_chalenged)
		fail.is_simulation = is_simulation
		add_child(fail)

func init_variables() -> void:
	question = random_question()
	waited = random_waited()
	expressions = question.get("expression")
	variables = question.get("variable")
	assigns = question.get("assign")
	assigns_type = question.get("assign_type")
	shapes_type = question.get("shape_type")

func init_components() -> void:
	$chalenge.text = tr("CHALLENGING") + " " + codemon_chalenged.capitalize()
	$capture.set_disabled(true)
	$btn_1/btn.grab_focus()

func init_connections() -> void:
	$capture.connect("pressed", self, "execute_expression")
	$debuger.connect("button_down", self, "debuger_pressed")
	warning.get_node("box/ok").connect("pressed", self, "ok_warning")
	
func ok_warning() -> void:
	result_chalenge()

func debuger_pressed() -> void:
	print(values)

func check_filled_btn() -> void:
	update_values_selected()
	$capture.set_disabled(!is_filled())

func is_filled() -> bool:
	for expression in expressions:
		for e in expression.split(" ", true, 0):
			var temp: String = e.replace("#","").replace("@","")
			if temp != "d" and values.keys().has(temp) and values.get(temp).get("type") == null:
				return false
	return true
	
func init_execute_expression() -> void:
	$debuger.visible = true
	$capture.disabled = true
	$flee.disabled = true
	$help.disabled = true
	$btn_1/btn.disabled = true
	$btn_1/label.disabled = true
	$btn_2/btn.disabled = true
	$btn_2/label.disabled = true
	$btn_3/btn.disabled = true
	$btn_3/label.disabled = true

func execute_expression() -> void:
	init_execute_expression()
	var control: String = ""
	var for_value
	var condition_index: int = 0
	var jump: bool = false
	var count: int = 0
	for i in range(expressions.size()):
		var loop: bool = true
		if !jump:
			while(loop):
				if is_control(assigns_type[i]):
					control = assigns_type[i]
					for_value = (convert_value(expressions[i])
								if typeof(convert_value(expressions[i])) == TYPE_INT 
								else get_array_value(variables[i]).back())
				condition_index = i if ["while", "if"].has(assigns_type[i]) else condition_index
				var temp = routine_expression(i, control, for_value, condition_index)
				jump = typeof(temp) == 2 and temp == 4
				loop = ((typeof(temp) == TYPE_OBJECT) 
						and ["while", "for"].has(control))
				control = "" if typeof(temp) == 2 and (temp == 6 or temp == 4) else control
				yield($debuger, "pressed")
				count = count + 1
				if count >= 10:
					warning.type = "no_infinite"
					add_child(warning)
					$debuger.visible = false
		else:
			jump = false 
	draw_debugger(expressions.size(), [values.get(question.get("return")).get("value")], false)
	yield($debuger, "pressed")
	$debuger.visible = false
	return_value = String(values.get(question.get("return")).get("value"))
	result_chalenge()

func routine_expression(i: int, control: String, for_value, condition_index: int) -> void:
	expressions[i] = refactory_expression(expressions[i], i)
	var values_array: Array = get_array_value(variables[i])
	draw_debugger(i, values_array, is_control(assigns_type[i]))
	if !is_same_type(values_array, i):
		warning.type = "no_type"
		add_child(warning)
		$debuger.visible = false
		return -1
	if !is_control(assigns_type[i]):
		if control == "for" and value_d.value < for_value - 1:
			values[assigns[i]].value = build_expression(i)
			values[assigns[i]].type = assigns_type[i]
			value_d.value = value_d.value + 1
			value_d.type = "int"
			yield($debuger, "pressed")
			return 2
		elif control == "while":
			values[assigns[i]].value = build_expression(i)
			values[assigns[i]].type = assigns_type[i]
			var loop_while: bool = build_expression(condition_index)
			if loop_while:
				yield($debuger, "pressed")
				return 3
		elif control == "if":
			var if_case: bool = build_expression(condition_index)
			if if_case:
				values[assigns[i]].value = build_expression(i)
				values[assigns[i]].type = assigns_type[i]
				yield($debuger, "pressed")
		else:
			values[assigns[i]].value = build_expression(i)
			values[assigns[i]].type = assigns_type[i]
			return 6
	else:
		var jump_case: bool = (check_for(value_d.value, for_value)
								if control == "for" 
								else !build_expression(condition_index))
		jump_case = !jump_case if control == "else" else jump_case
		if jump_case:
			return 4
	return 1

func check_for(value_d, for_value) -> bool:
	if typeof(for_value) != TYPE_INT:
		warning.codemon_type1 = variables_code.get(typeof(for_value))
		warning.codemon_type2 = variables_code.get(typeof(1))
		warning.type = "no_type"
		add_child(warning)
		$debuger.visible = false
		return false
	else:
		return value_d >= for_value


func build_expression(index: int):
	var values_array : Array =  get_array_value(variables[index])
	check_expression(index)
	var e : Expression = Expression.new()
	e.parse(expressions[index], PoolStringArray(variables[index]))
	var value = (stepify(float(e.execute(values_array)), 0.1)  
				if assigns_type[index] == "double"
				else e.execute(values_array))
	return value

func check_expression(index: int) -> void:
	var values_array : Array =  get_array_value(variables[index])
	var expression: String = expressions[index]
	type_and_or(expression)
	same_type_on_expression(expression, values_array)
	divide_by_zero(expression, values_array)
	operator_not_exist(index, values_array)
	operator_with_boolean(index, values_array)

func operator_with_boolean(index: int, values_array: Array):
	var e_array: PoolStringArray = expressions[index].split(" ", true, 0)
	var type1: int = (typeof(values.get(e_array[0]).value) 
			if values.get(e_array[0]) != null
			else typeof(convert_value(e_array[0])))
	var operator: String = (""
						if gambi.get(e_array[1]) == null
						else  gambi.get(e_array[1]))
	var type2: int = (typeof(values.get(e_array[2]).value) 
			if values.get(e_array[2]) != null
			else typeof(convert_value(e_array[2])))
	if type1 == TYPE_BOOL and type2 == TYPE_BOOL and !["and", "or", "not_equal", "equal"].has(operator):
		warning.codemon_type1 = variables_code.get(type1)
		warning.codemon_type2 = variables_code.get(type2)
		warning.operator = operator
		warning.type = "no_expression"
		add_child(warning)
		$debuger.visible = false
		return
	

func operator_not_exist(index: int, values_array: Array) -> void:
	var e : Expression = Expression.new()
	e.parse(expressions[index], PoolStringArray(variables[index]))
	var value = (convert_value(e.execute(values_array)) 
			if assigns_type[index] == "double"
			else e.execute(values_array))
	if value == null:
		var e_array: PoolStringArray = expressions[index].split(" ", true, 0)
		var type1: int = (typeof(values.get(e_array[0]).value) 
					if values.get(e_array[0]) != null
					else typeof(convert_value(e_array[0])))
		var operator: String = gambi.get(e_array[1])
		var type2: int = (typeof(values.get(e_array[2]).value) 
					if values.get(e_array[2]) != null
					else typeof(convert_value(e_array[2])))
		warning.codemon_type1 = variables_code.get(type1)
		warning.codemon_type2 = variables_code.get(type2)
		warning.operator = operator
		warning.type = "no_expression"
		add_child(warning)
		$debuger.visible = false
		return

func divide_by_zero(expression: String, values_array: Array) -> void:
	var e_array: PoolStringArray = expression.split(" ", true, 0)
	var value =(e_array[e_array.size() - 1]
				if values.get(e_array[e_array.size() - 1]) == null 
				else values.get(e_array[e_array.size() - 1]).get("value"))
	value = convert_value(value)
	if expression.match("*/*") and value == 0:
		warning.type = "no_divide_zero"
		add_child(warning)
		$debuger.visible = false
		return

func type_and_or(expression: String) -> void:
	for e in expression.split(" ", true, 0):
		if ((expression.match("*and*") or expression.match("*or*"))
				and !["or", "and", false, true].has(convert_value(e))
				and !["True", "False"].has(String(values.get(e).value))):
			warning.codemon_type1 = variables_code.get(typeof(values.get(e).value))
			warning.codemon_type2 = variables_code.get(typeof(false))
			warning.type = "no_type"
			add_child(warning)
			$debuger.visible = false
			return

func same_type_on_expression(expression: String, values_array: Array) -> void:
	var previous_type: int = -1
	for e in expression.split(" ", true, 0):
		if !symbols.values().has(e):
			var value = convert_value(e) if values.get(e) == null else values.get(e).value
			var type: int = typeof(value)
			if previous_type != -1 and previous_type != type:
				warning.codemon_type1 = variables_code.get(previous_type)
				warning.codemon_type2 = variables_code.get(type)
				warning.type = "no_type"
				add_child(warning)
				$debuger.visible = false
				return
			previous_type = type


func is_same_type(values_array: Array, index: int) -> bool:
	var previous_type = variables_code.get(typeof(values_array[0]))
	var type = control_type(assigns_type[index])
	if (previous_type != type and !expressions[index].match("*>*") 
			and !expressions[index].match("*<*") and !expressions[index].match("*==*")
			and !expressions[index].match("*!=*")
			and assigns_type[index] != "else"):
		warning.codemon_type1 = previous_type
		warning.codemon_type2 = type
		$debuger.visible = false
		return false
	return true

func convert_value(value):
	if ["true", "false", "True", "False"].has(String(value)):
		return bool(value)
	elif ((value != null and typeof(value) == TYPE_STRING and !value.match("*.*") and value.is_valid_integer()) 
		 or (value != null and typeof(value) != TYPE_STRING and !String(value).match("*.*") and String(value).is_valid_integer())):
		 return int(value)
	elif value != null and String(value).is_valid_float():
		return stepify(float(value), 0.1)
	else:
		return value

func is_control(word: String) -> bool:
	return ["for", "if", "else", "while"].has(word)

func refactory_expression(expression: String, index: int) -> String:
	for e in expression.split(" ", true, 0):
		if e.begins_with("#") or e.begins_with("@"):
			var last: String = e.substr(e.length()-1) 
			values.get(last)["value"] = symbols.get(values.get(last).get("type"))
			expression = expression.replace(e, values.get(last).get("value"))
	if expression.match("*%*") and assigns_type[index] == "double":
		expression = expression.replace("%", ",")
		expression = "fmod(" + expression + ")"
	print(expression)
	return expression


func draw_debugger(index: int, values_array: Array, is_control: bool) -> void:
	var shapes: Array =  $function/vbox.get_child(index).get_children()
	var count: int = 0
	for i in range(shapes.size()):
		if shapes[i].is_in_group("shape"):
			shapes[i].get_node("animation").play("pop_up")
			shapes[i].get_node("balloon/value").text = String(values_array[count])
			count = count + 1


func draw_expression() -> void:
	var is_control: bool = false
	for i in range(expressions.size()):
		var hbox: HBoxContainer = HBoxContainer.new()
		hbox.set("custom_constants/separation", 10)
		if is_control:
			hbox.add_child($hint/space.duplicate())
		is_control = draw_assign(i, hbox)
		if expressions[i] != "else":
			for c in expressions[i].split(" ", true, 0):	
				if ["a", "b", "c", "d", "#a", "#b","#c","#d","@a", "@b", "@c", "@d"].has(c):
					hbox.add_child(get_shape(c, false))
				else:
					var label: Label = $clone.duplicate()
					label.text = c
					hbox.add_child(label)
		$function/vbox.add_child(hbox)
	draw_return()
	$function/value_waited.text = waited


func case_for(index: int, hbox: HBoxContainer) -> void:
	var control: Label = $clone.duplicate()
	control.text = assigns_type[index]
	var in_range: Label = $clone.duplicate()
	in_range.text = "in range "
	hbox.add_child(control)
	hbox.add_child(get_shape(assigns[index], false))
	hbox.add_child(in_range)
	value_d.type = "int"
	value_d.value = 0


func case_control(index: int, hbox: HBoxContainer) -> void:
	var control: Label = $clone.duplicate()
	control.text = assigns_type[index]
	hbox.add_child(control)


func draw_assign(index: int, hbox: HBoxContainer) -> bool:
	if ["for", "if", "else", "while"].has(assigns_type[index]):
		if assigns_type[index] == "for":
			case_for(index, hbox)
		else:
			case_control(index, hbox)
		return true
	else:
		hbox.add_child(get_shape(assigns[index], true))
		var equal: Label = $clone.duplicate()
		equal.text = "="
		if assigns[index] == "d":
			var type: Label = $clone.duplicate()
			var sprite : TextureRect = TextureRect.new()
			sprite.texture = load("res://art/character/codemon/"+ assigns_type[index] +".png")
			hbox.add_child(type)
			hbox.add_child(sprite)
		hbox.add_child(equal)
		return false


func draw_return() -> void:
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.set("custom_constants/separation", 3)	
	var label: Label = $clone.duplicate()
	label.text = "return"
	hbox.add_child(label)
	hbox.add_child(get_shape(question.get("return"), false))
	$function/vbox.add_child(hbox)


func get_shape(expression: String, is_assign: bool) -> TextureRect:
	var shape : TextureRect = preload("res://scene/component/shape.tscn").instance()
	if !is_assign:
		shape.add_to_group("shape")
	if expression.begins_with("#"):
		shape.texture = load("res://art/chalenge/analyze_algorithm/square.png")
	elif expression.begins_with("@"):
		shape.texture = load("res://art/chalenge/analyze_algorithm/circle.png")
	else:
		shape.texture = load("res://art/chalenge/analyze_algorithm/triangle.png")
	return set_color_shape(expression, shape)


func set_color_shape(expression: String, shape: TextureRect) -> TextureRect:
	if expression.ends_with("a"):
		shape.self_modulate = Color("ff7777")
	elif expression.ends_with("b"):
		shape.self_modulate = Color("7777ff")
	elif expression.ends_with("c"):
		shape.self_modulate = Color("77ff77")
	return shape


func update_values_selected() -> void:
	values.a.value = get_value_variable($btn_1)
	values.a.type = null if $btn_1.codemon_selected.empty() else $btn_1.codemon_selected
	values.b.value = get_value_variable($btn_2)
	values.b.type = null if $btn_2.codemon_selected.empty() else $btn_2.codemon_selected
	values.c.value = get_value_variable($btn_3)
	values.c.type = null if $btn_3.codemon_selected.empty() else $btn_3.codemon_selected


func get_value_variable(btn : Control):
	if btn.codemon_selected == "int":
		return int(btn.get_node("label/text").text)
	elif btn.codemon_selected == "double":
		var text: String = btn.get_node("label/text").text
		return stepify(float(text), 0.1)
	elif btn.codemon_selected == "bool":
		return btn.get_node("label/text").text == "true"
	elif btn.codemon_selected == "string":
		return btn.get_node("label/text").text
	else:
		return null


func control_type(assign_type: String) -> String:
	if assign_type == "for":
		return "int"
	elif ["while", "if", "else"].has(assign_type):
		return "bool"
	return assign_type
	
	
func get_array_value(variable: Array) -> Array:
	var temp : Array
	for v in variable:
		temp.append(values.get(v).get("value"))
	return temp


func random_question() -> Dictionary:
	var questions: Array = persistence.get("questions_" + codemon_chalenged)
	if number_question == -1:
		randomize()
		var index: int = randi() % questions.size()
		return questions[index]
	else:
		return questions[number_question]

func random_waited() -> String:
	var waiteds: Array = question.get("waited")
	randomize()
	var index: int = randi() % waiteds.size()
	return waiteds[index]


func update_sprite() -> void:
	var sprite: KinematicBody2D = load(codemons.get(codemon_chalenged)).instance()
	sprite.position = Vector2(835, 363)
	sprite.play_idle()
	add_child(sprite)


func update_level() -> void:
	for i in shapes_type.size():
		if shapes_type[i] == "hide":
			get_node("btn_" + String(i + 1)).visible = false
			get_node("symbol/s_" + String(i + 1)).visible = false
			get_node("equals/e_" + String(i + 1)).visible = false
		else:
			get_node("btn_" + String(i + 1)).set_type(shapes_type[i])
			get_node("symbol/s_" + String(i + 1)).texture = load(
				"res://art/chalenge/analyze_algorithm/" + shapes_type[i] + ".png")



func _on_debuger_button_down() -> void:
	$debuger/animation.play("clicked")

func _on_debuger_button_up() -> void:
	$debuger/animation.play("normal")

func _on_flee_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_help_pressed() -> void:
	var help_instance: CanvasLayer = help.instance()
	help_instance.set_image(codemon_chalenged)
	add_child(help_instance)
