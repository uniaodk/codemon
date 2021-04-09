extends KinematicBody2D

const SPEED: int = 300
const ACCELERATION: int = 2500
const FRICTION: int = 2500

export (String) var codemon = ""

var velocity: Vector2 = Vector2.ZERO
onready var animation_state: AnimationNodeStateMachinePlayback = $animation_tree.get("parameters/playback")
var effect_player: AudioStreamPlayer = AudioStreamPlayer.new()

signal chalenge_entered(object, codemon)
signal chalenge_exited(object)

var time_wait: float = 0

func _ready() -> void:
	connect("chalenge_entered", get_parent().get_parent(), "_on_chalenge_entered")
	connect("chalenge_exited", get_parent().get_parent(), "_on_chalenge_exited")
	animation_state.start("idle")
	effect_player.set_bus("effect")
	if ['Double','Int', 'Bool', 'For', 'And', 'Else', 'Plus'].has(codemon):
		effect_player.stream = load("res://audio/sfx/jump_2.ogg")
	else:
		effect_player.stream = load("res://audio/sfx/jump_1.ogg")
	add_child(effect_player)

func play_idle() -> void:
	$animation.play("idle_left")
	$animation_tree.active = false

func _process(delta: float) -> void:
	volume_distance()
	if time_wait > 3 and $animation_tree.active:
		randomize()
		var vector : Vector2 = Vector2.ZERO
		vector.x = -1 + randi() % 3
		vector.y = -1 + randi() % 3
		vector = vector.normalized()
		config_movimentation(vector, delta)
		time_wait = 0
	time_wait = time_wait + delta
	velocity = move_and_slide(velocity)

func config_movimentation(vector: Vector2, delta: float) -> void:
	if vector != Vector2.ZERO:
		$animation_tree.set("parameters/idle/blend_position", vector)
		$animation_tree.set("parameters/walk/blend_position", vector)
		animation_state.travel("walk")
		if !effect_player.is_playing():
			effect_player.play()
		velocity = velocity.move_toward(vector * SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		effect_player.stop()
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _on_chalenge_body_entered(_body: Node) -> void:
	emit_signal("chalenge_entered", codemon, self)


func _on_chalenge_body_exited(_body: Node) -> void:
	emit_signal("chalenge_exited", codemon)

func get_distance_player() -> float:
	var player: KinematicBody2D = game.get_child_by_name(get_parent(), "player")
	return player.position.distance_to(position) if player != null else 1000
	
func volume_distance() -> void:
	var dist_perc: int = get_distance_player() / 75
	effect_player.volume_db = dist_perc * -4
