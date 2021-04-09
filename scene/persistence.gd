extends Node

var questions_int: Array
var questions_double: Array
var questions_string: Array
var questions_bool: Array

var questions_plus : Array
var questions_minus : Array
var questions_multiply : Array
var questions_divide : Array
var questions_modulo : Array

var questions_bigger : Array
var questions_less : Array
var questions_equal : Array
var questions_not_equal : Array
var questions_and : Array
var questions_or : Array

var questions_for : Array
var questions_while : Array
var questions_if : Array
var questions_else : Array

func _ready() -> void:
	questions_int = load_questions("int")
	questions_double = load_questions("double")
	questions_string = load_questions("string")
	questions_bool = load_questions("bool")
	
	questions_plus = load_questions("plus")
	questions_minus = load_questions("minus")
	questions_multiply = load_questions("multiply")
	questions_divide = load_questions("divide")
	questions_modulo = load_questions("modulo")
	
	questions_bigger = load_questions("bigger")
	questions_less = load_questions("less")
	questions_equal = load_questions("equal")
	questions_not_equal = load_questions("not_equal")
	questions_and = load_questions("and")
	questions_or = load_questions("or")
	
	questions_for = load_questions("for")
	questions_while = load_questions("while")
	questions_if = load_questions("if")
	questions_else = load_questions("else")


func load_questions(name_file: String) -> Array:
	var file: File = File.new()
	file.open("res://data/question_" + name_file + ".json", File.READ)
	var json: JSONParseResult = JSON.parse(file.get_as_text())
	file.close()
	return json.result
	
func get_game_data() -> Dictionary:
	return {"map_visited": game.map_visited,
			"current_map": game.current_map,
			"status_challenge": game.status_challenge,
			"status_capture": game.status_capture,
			"is_new_game": game.is_new_game,
			"did_get_notebook": game.did_get_notebook,
			"is_finished_game": game.is_finished_game,
			"is_chated_doorman": game.is_chated_doorman,
			"volume_music": game.volume_music,
			"volume_effect": game.volume_effect,
			"is_muted_music": game.is_muted_music,
			"is_muted_effect": game.is_muted_effect,
			"energy": game.energy,
			"coin": game.coin,
			"left_time_coin": game.left_time_coin,
			"is_active_buff_coin": game.is_active_buff_coin,
			"left_time_capture": game.left_time_capture,
			"is_active_buff_capture": game.is_active_buff_capture,
			"battery": game.battery,
			"pen_coin": game.pen_coin,
			"pen_capture": game.pen_capture,
			"misson_variable": game.misson_variable,
			"mission_operator": game.mission_operator,
			"mission_logic": game.mission_logic,
			"mission_control": game.mission_control,
			"dialogue_forest": game.dialogue_forest,
			"dialogue_mountain": game.dialogue_mountain,
			"dialogue_beach": game.dialogue_beach,
			"dialogue_desert": game.dialogue_desert,
			"dialogue_boss": game.dialogue_boss,
			"show_tutorial_question": game.show_tutorial_question,
			"show_tutorial_circuit": game.show_tutorial_circuit,
			"show_tutorial_analyze_1": game.show_tutorial_analyze_1,
			"show_tutorial_analyze_2": game.show_tutorial_analyze_2,
			"show_tutorial_if": game.show_tutorial_if,
			"show_tutorial_while": game.show_tutorial_while,
			"show_tutorial_for": game.show_tutorial_for,
			"show_tutorial_else": game.show_tutorial_else,
			"show_tutorial_bubble": game.show_tutorial_bubble,
			"bubble_quest": game.bubble_quest,
			"language": game.language
	}

func set_game_data(data: Dictionary) -> void:
	game.map_visited = data.get("map_visited")
	game.current_map = data.get("current_map")
	game.status_challenge = data.get("status_challenge")
	game.status_capture = data.get("status_capture")
	game.is_new_game = data.get("is_new_game")
	game.did_get_notebook = data.get("did_get_notebook")
	game.is_finished_game = data.get("is_finished_game")
	game.is_chated_doorman = data.get("is_chated_doorman")
	game.volume_music = data.get("volume_music")
	game.volume_effect = data.get("volume_effect")
	game.is_muted_music = data.get("is_muted_music")
	game.is_muted_effect = data.get("is_muted_effect")
	game.energy = data.get("energy")
	game.coin = data.get("coin")
	game.left_time_coin = data.get("left_time_coin")
	game.left_time_capture = data.get("left_time_capture")
	game.is_active_buff_coin = data.get("is_active_buff_coin")
	game.is_active_buff_capture = data.get("is_active_buff_capture")
	game.battery = data.get("battery")
	game.pen_coin = data.get("pen_coin")
	game.pen_capture = data.get("pen_capture")
	game.misson_variable = data.get("misson_variable")
	game.mission_operator = data.get("mission_operator")
	game.mission_logic = data.get("mission_logic")
	game.mission_control = data.get("mission_control")
	game.dialogue_forest = data.get("dialogue_forest")
	game.dialogue_mountain = data.get("dialogue_mountain")
	game.dialogue_beach = data.get("dialogue_beach")
	game.dialogue_desert = data.get("dialogue_desert")
	game.dialogue_boss = data.get("dialogue_boss")
	game.show_tutorial_question = data.get("show_tutorial_question")
	game.show_tutorial_circuit = data.get("show_tutorial_circuit")
	game.show_tutorial_analyze_1 = data.get("show_tutorial_analyze_1")
	game.show_tutorial_analyze_2 = data.get("show_tutorial_analyze_2")
	game.show_tutorial_if = data.get("show_tutorial_if")
	game.show_tutorial_while = data.get("show_tutorial_while")
	game.show_tutorial_for = data.get("show_tutorial_for")
	game.show_tutorial_else = data.get("show_tutorial_else")
	game.show_tutorial_bubble = data.get("show_tutorial_bubble")
	game.bubble_quest = data.get("bubble_quest")
	game.language = data.get("language")

func load_progress() -> void:
	var file: File = File.new()
	var d = Directory.new()
	if !(d.dir_exists("res://data")):
		d.open("res://")
		d.make_dir("res://data")
		save_progress()
	file.open("res://save.data", File.READ)
	var json: JSONParseResult = JSON.parse(file.get_as_text())
	file.close()
	var data = json.result
	if data != null:
		set_game_data(data)
	
func save_progress() -> void:
	var file: File = File.new()
	file.open("res://save.data", File.WRITE)
	file.store_line(to_json(get_game_data()))
	file.close()
