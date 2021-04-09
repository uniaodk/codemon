extends Control

export (String, "string", "intt") var codemon

onready var codemon_resource: Resource = load("res://scene/character/codemons/" + codemon + ".tscn")


func _ready() -> void:
	var codemon_scene = codemon_resource.instance()
	codemon_scene.play_idle()
	codemon_scene.get_node("animation").stop(true)
	$sprite.frame = 0
	$codemon.add_child(codemon_scene)
	$animation.connect("animation_finished", self, "on_finished_animation")

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept"):
#		$animation.play("pop")

func on_finished_animation(anim_name: String) -> void:
	if anim_name == "pop":
		$codemon.get_child(0).play_idle()

func update_codemon(codemon: String) -> void:
	codemon_resource = load("res://scene/character/codemons/" + codemon + ".tscn")
	var codemon_scene = codemon_resource.instance()
	codemon_scene.play_idle()
	codemon_scene.get_node("animation").stop(true)
	$sprite.frame = 0
	$codemon.remove_child($codemon.get_child(0))
	$codemon.add_child(codemon_scene)
	
func play_click() -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/bubble.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	music_player.play()
	add_child(music_player)
	yield(music_player, "finished")
	remove_child(music_player)


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "pop":
		play_click()
