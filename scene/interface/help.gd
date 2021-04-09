extends CanvasLayer

func set_image(codemon: String) -> void:
	var tip_title: Control = load("res://scene/interface/tip_title.tscn").instance()
	tip_title.codemon = codemon
	$img.texture = load("res://art/tutorial/"+ codemon +".png")
	$img.add_child(tip_title)

func _ready() -> void:
	translation();

func translation() -> void:
	$title.text = tr("HELP");
	$ok/btn_name.text = "Ok";
	
func _on_ok_pressed() -> void:
	queue_free()

func get_image() -> Node:
	return $img
