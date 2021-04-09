extends CanvasLayer

var play : String = "intro"
var is_dialogue_choice : bool = false
var is_finish_tween : bool = false
var bubble_quest: int = 1

onready var dialogue : Node = self.get_node(play)
onready var tip_title: Control = load("res://scene/interface/tip_title.tscn").instance()

func run() -> void:
	dialogue.start_dialogue()
	$dialog_help/img.add_child(tip_title)

func _process(_delta : float) -> void:
	var is_input_pressed : bool = Input.is_action_just_pressed("ui_accept")
	if  is_input_pressed and !is_dialogue_choice and is_finish_tween:
		dialogue.next_dialogue()

func create_dialogue_box(ref: String, actor: String, text: String) -> void:
	$dialog_help.visible = !ref.empty()
	if !ref.empty():
		tip_title.codemon = ref
		tip_title._ready()
		$dialog_help/img.texture = load("res://art/tutorial/"+ ref +".png")
	is_finish_tween = false
	$dialogue_box/sprite_btn.hide()
	$dialogue_box/actor.text = tr(actor);
	$dialogue_box/text.text = tr(text);
	$dialogue_box/text.percent_visible = 0
	$dialogue_box/tween.interpolate_property($dialogue_box/text, "percent_visible",
		0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$dialogue_box/tween.start()

func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	is_finish_tween = true
	$dialogue_box/sprite_btn.show()

func end_dialogue() -> void:
	$dialogue_box.hide()
	get_parent().emit_signal("end_dialogue", play)
	queue_free()
	
func start_dialogue() -> void:
	$dialogue_choice.hide()
	$dialogue_box/sprite_btn.hide()
	$dialogue_box.show()
	
func create_dialogue_choice(choices: Array) -> void:
	is_dialogue_choice = true
	$dialogue_box/sprite_btn.hide()
	$dialogue_choice.show()
	clear_dialogue_choice()
	create_choices(choices)
	$dialogue_choice/container.get_child(0).grab_focus()

func clear_dialogue_choice() -> void:
	for i in $dialogue_choice/container.get_children():
		i.free()

func create_choices(choices: Array) -> void:
	var button : Resource = load("res://scene/component/btn_normal.tscn")
	for i in range (0, choices.size()):
		var btn: TextureButton  = button.instance()
		btn.get_node("btn_name").text = tr(choices[i].Dialogue);
		btn.connect("pressed", self, "choice_pressed", [i])
		$dialogue_choice/container.add_child(btn)

func choice_pressed(choice : int) -> void:  
	dialogue.next_dialogue(choice)
	$dialogue_choice.hide()
	is_dialogue_choice = false

# start dialogue
func _on_street_introduction_dialogue_started() -> void:
	start_dialogue()

func _on_laboratory_part_1_dialogue_started() -> void:
	start_dialogue()

func _on_laboratory_part_2_dialogue_started() -> void:
	start_dialogue()

func _on_laboratory_tutorial_dialogue_started() -> void:
	start_dialogue()

func _on_forest_tutorial_dialogue_started() -> void:
	start_dialogue()

func _on_montain_tutorial_dialogue_started() -> void:
	start_dialogue()

func _on_bubble_dialogue_started() -> void:
	start_dialogue()

func _on_beach_tutorial_dialogue_started() -> void:
	start_dialogue()
	
func _on_desert_tutorial_dialogue_started() -> void:
	start_dialogue()

func _on_boss_tutorial_dialogue_started() -> void:
	start_dialogue()

func _on_doorman_dialogue_started() -> void:
	start_dialogue()

func _on_bubble_good_dialogue_started() -> void:
	start_dialogue()
	
func _on_simlator_dialogue_started() -> void:
	start_dialogue()
	

# end dialogue
func _on_street_introduction_dialogue_ended() -> void:
	end_dialogue()

func _on_laboratory_part_1_dialogue_ended() -> void:
	end_dialogue()

func _on_laboratory_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_forest_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_montain_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_laboratory_part_2_dialogue_ended() -> void:
	if game.did_get_notebook:
		play = "laboratory_tutorial"
		dialogue = self.get_node(play)
		dialogue.start_dialogue()
	else:
		end_dialogue()
		
func _on_bubble_dialogue_ended() -> void:
	end_dialogue()
	
func _on_beach_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_desert_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_boss_tutorial_dialogue_ended() -> void:
	end_dialogue()

func _on_doorman_dialogue_ended() -> void:
	end_dialogue()

func _on_bubble_good_dialogue_ended() -> void:
	end_dialogue()
	
func _on_simlator_dialogue_ended() -> void:
	end_dialogue()


# create dialogue box
func _on_street_introduction_dialogue_next(ref: String, actor: String, text: String) -> void:
	create_dialogue_box(ref, actor, text)

func _on_laboratory_part_1_dialogue_next(ref: String, actor: String, text: String) -> void:
	create_dialogue_box(ref, actor, text)

func _on_laboratory_part_2_dialogue_next(ref: String, actor: String, text: String) -> void:
	create_dialogue_box(ref, actor, text)

func _on_laboratory_tutorial_dialogue_next(ref: String, actor: String, text: String):
	create_dialogue_box(ref, actor, text)

func _on_forest_tutorial_dialogue_next(ref: String, actor: String, text: String) -> void:
	create_dialogue_box(ref, actor, text)

func _on_montain_tutorial_dialogue_next(ref: String, actor: String, text: String) -> void:
	create_dialogue_box(ref, actor, text)

func _on_bubble_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)	

func _on_beach_tutorial_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)

func _on_desert_tutorial_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)

func _on_boss_tutorial_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)

func _on_doorman_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)

func _on_bubble_good_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)

func _on_simlator_dialogue_next(ref, actor, text) -> void:
	create_dialogue_box(ref, actor, text)


# create dialogue choice
func _on_laboratory_tutorial_choice_next(_ref: String, choices: Array):
	create_dialogue_choice(choices)

func _on_forest_tutorial_choice_next(_ref: String, choices: Array) -> void:
	create_dialogue_choice(choices)

func _on_montain_tutorial_choice_next(_ref: String, choices: Array) -> void:
	create_dialogue_choice(choices)

func _on_beach_tutorial_choice_next(_ref, choices) -> void:
	create_dialogue_choice(choices)
	
func _on_desert_tutorial_choice_next(_ref, choices) -> void:
	create_dialogue_choice(choices)

func _on_boss_tutorial_choice_next(_ref, choices) -> void:
	create_dialogue_choice(choices)




# conditionals
func _on_laboratory_part_2_conditonal_data_needed() -> void:
	var cond = String(game.did_get_notebook).to_lower()
	dialogue.send_conditonal_data({"did_get_notebook" : cond})

func _on_bubble_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond" : int(game.bubble_quest)})

func _on_forest_tutorial_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.dialogue_forest)})

func _on_montain_tutorial_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.dialogue_mountain)})

func _on_beach_tutorial_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.dialogue_beach)})

func _on_desert_tutorial_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.dialogue_desert)})

func _on_boss_tutorial_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.dialogue_boss)})

func _on_doorman_conditonal_data_needed() -> void:
	dialogue.send_conditonal_data({"cond": int(game.is_chated_doorman)})
