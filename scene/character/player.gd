extends KinematicBody2D

const SPEED: int = 300
const ACCELERATION: int = 2500
const FRICTION: int = 2500

var velocity: Vector2 = Vector2.ZERO
var is_block_input: bool = false
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

onready var animation_state: AnimationNodeStateMachinePlayback = $animation_tree.get("parameters/playback")

func _ready() -> void:
	music_player.set_bus("effect")
	music_player.stream = load("res://audio/sfx/footstep.ogg")
	music_player.pause_mode = PAUSE_MODE_PROCESS
	add_child(music_player)

func play_animation(name: String, is_block: bool) -> void:
	is_block_input = is_block
	$animation_tree.active = !is_block_input
	if !name.empty():
		$animation.play(name)
		$animation_tree.set("parameters/idle/blend_position", _get_position(name))
	else:
		$animation_tree.active = true
		animation_state.travel("idle")
	if !is_block:
		$animation.stop()
		
		
# get vector2 to the position player after some action
func _get_position(name: String) -> Vector2:
	if name == "idle_left" or name == "idle_right":
		return Vector2(-1 if name == "idle_left" else 1, 0)
	else:
		return Vector2(0, -1 if name == "idle_up" else 1)


func _physics_process(delta: float) -> void:
	if !is_block_input:
		var input_vector : Vector2 = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
	
		config_movimentation(input_vector, delta)
		velocity = move_and_slide(velocity)


func config_movimentation(vector: Vector2, delta: float) -> void:
	if vector != Vector2.ZERO:
		$animation_tree.set("parameters/idle/blend_position", vector)
		$animation_tree.set("parameters/walk/blend_position", vector)
		animation_state.travel("walk")
		if !music_player.is_playing():
			music_player.play()
		velocity = velocity.move_toward(vector * SPEED, ACCELERATION * delta)
	else:
		music_player.stop()
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
