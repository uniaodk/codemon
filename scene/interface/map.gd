extends Control

onready var buttons: Array = [$laboratory, $forest, $mountain, $beach, $desert, $boss]
var map_travel: String = ""

func _ready() -> void:
	translation();
	for index in range(game.map_visited):
		buttons[index].disabled = false
	$laboratory.grab_focus()

func translation() -> void:
	$title.text = tr("MAP");
	$laboratory.hint_tooltip = tr("LAB");
	$forest.hint_tooltip = tr("F_VARIABLES");
	$mountain.hint_tooltip = tr("M_OPERATORS");
	$beach.hint_tooltip = tr("B_CONDITIONS");
	$desert.hint_tooltip = tr("D_CONTROLS");
	$boss.hint_tooltip = tr("BOSS");
	$back/btn_name.text = tr("BACK");
	$box_confirm/hbox_container/yes/btn_name.text = tr("YES");
	$box_confirm/hbox_container/no/btn_name.text = tr("NO");
	$box_confirm/question.text = tr("FAST_TRAVEL");

func _on_back_pressed() -> void:
	get_parent().get_node("delay").start(0.2)
	queue_free()


func _on_laboratory_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $laboratory.hint_tooltip
	map_travel = "laboratory"


func _on_forest_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $forest.hint_tooltip
	map_travel = "forest"


func _on_mountain_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $mountain.hint_tooltip
	map_travel = "mountain"


func _on_beach_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $beach.hint_tooltip
	map_travel = "beach"


func _on_desert_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $desert.hint_tooltip
	map_travel = "desert"


func _on_boss_pressed() -> void:
	$box_confirm.set_visible(true)
	$box_confirm/hbox_container/yes.grab_focus()
	$box_confirm/local.text = $boss.hint_tooltip
	map_travel = "boss"


func _on_travel_yes_pressed() -> void:
	$tween.interpolate_property(game.get_last_child_root(), "modulate:a8", 255, 0, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	self.hide()
	$tween.start()


func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	get_tree().change_scene("res://scene/map/"+ map_travel + ".tscn")


func _on_travel_no_pressed() -> void:
	$box_confirm.set_visible(false)
