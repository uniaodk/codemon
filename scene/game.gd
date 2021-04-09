extends Node

const PT: String = 'pt_BR';
const ENG: String = 'en';

# limits
const MAX_ITEM = 99
const MAX_COIN = 999

# maps
var map_visited: int = 1
var current_map: int = 0
const MAP_STREET: int = 0
const MAP_LAB: int = 1
const MAP_FOREST: int = 2
const MAP_MOUNTAIN: int = 3
const MAP_BEACH: int = 4
const MAP_DESERT: int = 5
const MAP_BOSS: int = 6

# codemons
const CODEMON_INT: String = "0"
const CODEMON_DOUBLE: String = '1'
const CODEMON_STRING: String = '2'
const CODEMON_BOOL: String = '3'
const CODEMON_PLUS: String = '4'
const CODEMON_MINUS: String = '5'
const CODEMON_MULTIPLY: String = '6'
const CODEMON_DIVIDE: String = '7'
const CODEMON_MODULE: String = '8'
const CODEMON_LESS: String = '9'
const CODEMON_BIGGER: String = '10'
const CODEMON_EQUAL: String = '11'
const CODEMON_NOTT: String = '12'
const CODEMON_ANDD: String = '13'
const CODEMON_ORR: String = '14'
const CODEMON_FOR: String = '15'
const CODEMON_WHILE: String = '16'
const CODEMON_IF: String = '17'
const CODEMON_ELSE: String = '18'
const CODEMON_ARRAY: String = '19'

var language: String = ENG;

var codemon_name: Dictionary = {CODEMON_INT: "int", CODEMON_DOUBLE: "double",
									CODEMON_STRING: "string",
									CODEMON_BOOL: "bool", CODEMON_PLUS: "plus",
									CODEMON_MINUS: "minus", CODEMON_MULTIPLY: "multiply",
									CODEMON_DIVIDE: "divide", CODEMON_MODULE: "modulo",
									CODEMON_LESS: "less", CODEMON_BIGGER: "bigger",
									CODEMON_EQUAL: "equal", CODEMON_NOTT: "not_equal",
									CODEMON_ANDD: "and", CODEMON_ORR: "or",
									CODEMON_FOR: "for", CODEMON_WHILE: "while",
									CODEMON_IF: "if", CODEMON_ELSE: "else",
									CODEMON_ARRAY: "array"}

# statistic
var status_challenge: Dictionary = {CODEMON_INT: 0, CODEMON_DOUBLE: 0,
									CODEMON_STRING: 0,
									CODEMON_BOOL: 0, CODEMON_PLUS: 0,
									CODEMON_MINUS: 0, CODEMON_MULTIPLY: 0,
									CODEMON_DIVIDE: 0, CODEMON_MODULE: 0,
									CODEMON_LESS: 0, CODEMON_BIGGER: 0,
									CODEMON_EQUAL: 0, CODEMON_NOTT: 0,
									CODEMON_ANDD: 0, CODEMON_ORR: 0,
									CODEMON_FOR: 0, CODEMON_WHILE: 0,
									CODEMON_IF: 0, CODEMON_ELSE: 0,
									CODEMON_ARRAY: 0}
var status_capture: Dictionary = {CODEMON_INT: 3, CODEMON_DOUBLE: 3,
									CODEMON_STRING: 3,
									CODEMON_BOOL: 3, CODEMON_PLUS: 3,
									CODEMON_MINUS: 3, CODEMON_MULTIPLY: 3,
									CODEMON_DIVIDE: 3, CODEMON_MODULE: 3,
									CODEMON_LESS: 3, CODEMON_BIGGER: 3,
									CODEMON_EQUAL: 3, CODEMON_NOTT: 3,
									CODEMON_ANDD: 3, CODEMON_ORR: 3,
									CODEMON_FOR: 3, CODEMON_WHILE: 3,
									CODEMON_IF: 3, CODEMON_ELSE: 3,
									CODEMON_ARRAY: 3}


# if is_new_game is going to play all intro scene
var is_new_game : bool = true
var did_get_notebook : bool = !is_new_game
var is_finished_game: bool = false
var is_chated_doorman: bool = true

# volume range (0 - 5) 0 is higher and 5 mute
var volume_music : int = 2
var volume_effect : int = 2
var is_muted_music : bool = false
var is_muted_effect : bool = false


# hud control
var energy: int = 10  #range 0 = empty to 10 = full
var coin: int = 500
var is_active_buff_coin: bool = false
var left_time_coin: int = 0
var is_active_buff_capture: bool = false
var left_time_capture: int = 0
var duration_buff_coin: int =  60 * 5
var duration_buff_capture: int = 60 * 5


var timer_buff_coin: Timer = Timer.new()
var timer_buff_capture: Timer = Timer.new()

# item owned
var battery: int = 20
var pen_coin: int = 20
var pen_capture: int = 20

# mission completed
var misson_variable: bool = false
var mission_operator: bool = false
var mission_logic: bool = false
var mission_control: bool = false

# tutorials
var dialogue_forest: bool = false
var dialogue_mountain: bool = false
var dialogue_beach: bool = false
var dialogue_desert: bool = false
var dialogue_boss: bool = false

var show_tutorial_question: bool = false
var show_tutorial_circuit: bool = false
var show_tutorial_analyze_1: bool = false
var show_tutorial_analyze_2: bool = false
var show_tutorial_if: bool = false
var show_tutorial_while: bool = false
var show_tutorial_for: bool = false
var show_tutorial_else: bool = false
var show_tutorial_bubble: bool = false

# gold codemon
var coin_codemon: Dictionary = {CODEMON_INT: 3, CODEMON_DOUBLE: 3,
									CODEMON_STRING: 3,
									CODEMON_BOOL: 3, CODEMON_PLUS: 6,
									CODEMON_MINUS: 6, CODEMON_MULTIPLY: 6,
									CODEMON_DIVIDE: 6, CODEMON_MODULE: 6,
									CODEMON_LESS: 9, CODEMON_BIGGER: 9,
									CODEMON_EQUAL: 9, CODEMON_NOTT: 9,
									CODEMON_ANDD: 9, CODEMON_ORR: 9,
									CODEMON_FOR: 15, CODEMON_WHILE: 15,
									CODEMON_IF: 15, CODEMON_ELSE: 15,
									CODEMON_ARRAY: 15}
									
# chance to capture a codemon
var capture_codemon: Dictionary = {CODEMON_INT: 0.4, CODEMON_DOUBLE: 0.4,
									CODEMON_STRING: 0.4,
									CODEMON_BOOL: 0.4, CODEMON_PLUS: 0.35,
									CODEMON_MINUS: 0.35, CODEMON_MULTIPLY: 0.35,
									CODEMON_DIVIDE: 0.35, CODEMON_MODULE: 0.35,
									CODEMON_LESS: 0.32, CODEMON_BIGGER: 0.32,
									CODEMON_EQUAL: 0.32, CODEMON_NOTT: 0.32,
									CODEMON_ANDD: 0.32, CODEMON_ORR: 0.32,
									CODEMON_FOR: 0.3, CODEMON_WHILE: 0.3,
									CODEMON_IF: 0.3, CODEMON_ELSE: 0.3,
									CODEMON_ARRAY: 0.3}

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var tween: Tween = Tween.new()
var is_in: bool = false
var music_rsc: Resource

var bubble_quest: int = 1

func _ready() -> void:
	config_timers()
	AudioServer.set_bus_volume_db(1, (4 - 6 * volume_music))
	AudioServer.set_bus_volume_db(2, (4 - 6 * volume_music))
	music_player.set_bus("music")
	music_player.stream = load("res://audio/music/boss_defeated.ogg")
	music_player.play()
	music_player.pause_mode = PAUSE_MODE_PROCESS
	add_child(music_player)
	add_child(tween)
	tween.connect("tween_completed", self, "on_tween_completed")
	
func change_music(music: Resource) -> void:
	tween.interpolate_property(music_player, "volume_db", music_player.volume_db , -30,
		2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	is_in = true
	music_rsc = music
	tween.start()

func on_tween_completed(_object: Object, _key: NodePath) -> void:
	if is_in:
		is_in = false
		music_player.stream = music_rsc
		tween.interpolate_property(music_player, "volume_db", -30 , (4 - 6 * volume_music),
			2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		music_player.play()
		tween.start()

func config_timers() -> void:
	timer_buff_capture.add_to_group("timer")
	timer_buff_coin.add_to_group("timer")
	timer_buff_capture.pause_mode = PAUSE_MODE_PROCESS
	timer_buff_coin.pause_mode = PAUSE_MODE_PROCESS

func run_dialogue(name: String, parent: Node) -> void:
	var dialogue = load("res://scene/interface/dialogue.tscn").instance()
	dialogue.play = name
	parent.add_child(dialogue)
	dialogue.run()

func get_last_child_add(parent: Node) -> Node:
	return parent.get_child(parent.get_child_count() -1)
	
func get_child_by_name(parent: Node, name: String) -> Node:
	for child in parent.get_children():
		if child.name == name:
			return child
	return null

func get_last_child_root() -> Node:
	return get_tree().root.get_child(get_tree().root.get_child_count() -1)
	
func add_interaction_btn(parent: Node, action: String, reference: String) -> void:
	var interaction : Control = load("res://scene/component/btn_interaction.tscn").instance()
	interaction.set_action(action, reference)
	parent.add_child(interaction)	

func subtract_energy() -> void:
	if !mission_control:
		game.energy = game.energy - 1 if game.energy > 0 else game.energy

func is_completed_forest_capture() -> bool:
	return (status_capture[CODEMON_INT] >= 3 and
			status_capture[CODEMON_DOUBLE] >= 3 and
			status_capture[CODEMON_STRING] >= 3 and
			status_capture[CODEMON_BOOL] >= 3)


func is_completed_mountain_capture() -> bool:
	return (status_capture[CODEMON_PLUS] >= 3 and
			status_capture[CODEMON_MINUS] >= 3 and
			status_capture[CODEMON_MULTIPLY] >= 3 and
			status_capture[CODEMON_DIVIDE] >= 3 and
			status_capture[CODEMON_MODULE] >= 3)


func is_completed_beach_capture() -> bool:
	return (status_capture[CODEMON_LESS] >= 3 and
			status_capture[CODEMON_BIGGER] >= 3 and
			status_capture[CODEMON_EQUAL] >= 3 and
			status_capture[CODEMON_NOTT] >= 3 and
			status_capture[CODEMON_ANDD] >= 3 and
			status_capture[CODEMON_ORR] >= 3)


func is_completed_desert_capture() -> bool:
	return (status_capture[CODEMON_IF] >= 3 and
			status_capture[CODEMON_ELSE] >= 3 and
			status_capture[CODEMON_WHILE] >= 3 and
			status_capture[CODEMON_FOR] >= 3)


func get_limited_item(has: int, bought: int) -> int:
	var total: int = has + bought
	return total if total <= MAX_ITEM else MAX_ITEM; 


func get_limited_gold(has: int, gain: int) -> int:
	var total: int = has + gain
	return total if total <= MAX_COIN else MAX_COIN; 


func get_amount_variable() -> int:
	return (status_capture[CODEMON_INT] + status_capture[CODEMON_DOUBLE] +
			status_capture[CODEMON_STRING] + status_capture[CODEMON_BOOL])


func get_amount_operator() -> int:
	return (status_capture[CODEMON_PLUS] + status_capture[CODEMON_MINUS] +
			status_capture[CODEMON_MULTIPLY] + status_capture[CODEMON_DIVIDE] +
			status_capture[CODEMON_MODULE])


func get_amount_logic() -> int:
	return (status_capture[CODEMON_LESS] + status_capture[CODEMON_BIGGER] +
			status_capture[CODEMON_EQUAL] + status_capture[CODEMON_NOTT] +
			status_capture[CODEMON_ANDD] + status_capture[CODEMON_ORR])
			


func get_amount_control() -> int:
	return (status_capture[CODEMON_IF] + status_capture[CODEMON_ELSE] +
			status_capture[CODEMON_FOR] + status_capture[CODEMON_WHILE])

func add_timer_buff_coin() -> void:
	if !timer_buff_coin.is_stopped():
		timer_buff_coin.start(timer_buff_coin.time_left + float(duration_buff_coin))

func add_timer_buff_capture() -> void:
	if !timer_buff_capture.is_stopped():
		timer_buff_capture.start(timer_buff_capture.time_left + float(duration_buff_capture))

func check_missions() -> void:
	misson_variable = get_amount_variable() >= 20
	mission_operator = get_amount_operator() >= 20
	mission_logic = get_amount_logic() >= 20
	mission_control = get_amount_control() >= 20

func reset_config() -> void:
	map_visited = 1
	current_map = 0
	status_challenge = {CODEMON_INT: 0, CODEMON_DOUBLE: 0,
									CODEMON_STRING: 0,
									CODEMON_BOOL: 0, CODEMON_PLUS: 0,
									CODEMON_MINUS: 0, CODEMON_MULTIPLY: 0,
									CODEMON_DIVIDE: 0, CODEMON_MODULE: 0,
									CODEMON_LESS: 0, CODEMON_BIGGER: 0,
									CODEMON_EQUAL: 0, CODEMON_NOTT: 0,
									CODEMON_ANDD: 0, CODEMON_ORR: 0,
									CODEMON_FOR: 0, CODEMON_WHILE: 0,
									CODEMON_IF: 0, CODEMON_ELSE: 0,
									CODEMON_ARRAY: 0}
	status_capture = {CODEMON_INT: 0, CODEMON_DOUBLE: 0,
									CODEMON_STRING: 0,
									CODEMON_BOOL: 0, CODEMON_PLUS: 0,
									CODEMON_MINUS: 0, CODEMON_MULTIPLY: 0,
									CODEMON_DIVIDE: 0, CODEMON_MODULE: 0,
									CODEMON_LESS: 0, CODEMON_BIGGER: 0,
									CODEMON_EQUAL: 0, CODEMON_NOTT: 0,
									CODEMON_ANDD: 0, CODEMON_ORR: 0,
									CODEMON_FOR: 0, CODEMON_WHILE: 0,
									CODEMON_IF: 0, CODEMON_ELSE: 0,
									CODEMON_ARRAY: 0}
	is_new_game = true
	did_get_notebook = !is_new_game
	is_finished_game = false
	is_chated_doorman = false
	energy = 10  #range 0 = empty to 10 = full
	coin = 0
	left_time_coin = 0
	is_active_buff_coin = false
	left_time_capture = 0
	is_active_buff_capture = false
	battery = 0
	pen_coin = 0
	pen_capture = 0

	# mission completed
	misson_variable = false
	mission_operator = false
	mission_logic = false
	mission_control = false

	# tutorials
	dialogue_forest = true
	dialogue_mountain = true
	dialogue_beach = true
	dialogue_desert = true
	dialogue_boss = true

	show_tutorial_question = true
	show_tutorial_circuit = true
	show_tutorial_analyze_1 = true
	show_tutorial_analyze_2 = true
	show_tutorial_if = true
	show_tutorial_while = true
	show_tutorial_for = true
	show_tutorial_else = true
	show_tutorial_bubble = true
