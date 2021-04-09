extends TextureRect

var txt: String
var vis_ok: bool

func _ready() -> void:
	$ok/btn_name.text = "Ok";
	$ok.visible = false

func show_tip(text: String, position: Vector2, vis_ok: bool) -> void:
	self.vis_ok = vis_ok
	self.rect_position = position
	$ok.visible = false
	$label.text = ""
	txt = text
	$animation.play("fade_in")

func _on_animation_animation_finished(anim_name: String) -> void:
	$tween.interpolate_property($label, "percent_visible",
		0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	$ok.visible = vis_ok


func _on_tween_tween_started(object: Object, key: NodePath) -> void:
	$label.text = txt
