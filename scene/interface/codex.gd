extends Control

func _ready() -> void:
	translation();
	config_btn_pressed_map()
	config_forest_statistic()
	config_mountain_statistic()
	config_beach_statistic()
	config_desert_statistic()
	
func translation() -> void:
	$status.text = tr("CHALLENGED") + "\n\n" + tr("CAPTURED");
	$forest/title.text = tr("F_VARIABLES");
	$mountain/title.text = tr("M_OPERATORS");
	$beach/title.text = tr("B_CONDITIONS");
	$desert/title.text = tr("D_CONTROLS");
	$hbox/btn_1/btn_name.text = "1";
	$hbox/btn_2/btn_name.text = "2";
	$hbox/btn_3/btn_name.text = "3";
	$hbox/btn_4/btn_name.text = "4";
	$back/btn_name.text = tr("BACK");

func config_forest_statistic() -> void:
	$forest/int.text = get_status(game.CODEMON_INT)
	set_silhouette(game.CODEMON_INT, $forest/hbox_codemon/int)
	
	$forest/double.text = get_status(game.CODEMON_DOUBLE)
	set_silhouette(game.CODEMON_DOUBLE, $forest/hbox_codemon/double)
		
	$forest/string.text = get_status(game.CODEMON_STRING)
	set_silhouette(game.CODEMON_STRING, $forest/hbox_codemon/string)
	
	$forest/bool.text = get_status(game.CODEMON_BOOL)
	set_silhouette(game.CODEMON_BOOL, $forest/hbox_codemon/bool)


func config_mountain_statistic() -> void:
	$mountain/plus.text = get_status(game.CODEMON_PLUS)
	set_silhouette(game.CODEMON_PLUS, $mountain/hbox_codemon/plus)
	
	$mountain/minus.text = get_status(game.CODEMON_MINUS)
	set_silhouette(game.CODEMON_MINUS, $mountain/hbox_codemon/minus)
	
	$mountain/multiply.text = get_status(game.CODEMON_MULTIPLY)
	set_silhouette(game.CODEMON_MULTIPLY, $mountain/hbox_codemon/multiply)
	
	$mountain/divide.text = get_status(game.CODEMON_DIVIDE)
	set_silhouette(game.CODEMON_DIVIDE, $mountain/hbox_codemon/divide)
	
	$mountain/module.text = get_status(game.CODEMON_MODULE)
	set_silhouette(game.CODEMON_MODULE, $mountain/hbox_codemon/module)

	
func config_beach_statistic() -> void:
	$beach/less.text = get_status(game.CODEMON_LESS)
	set_silhouette(game.CODEMON_LESS, $beach/hbox_codemon/less)
	
	$beach/bigger.text = get_status(game.CODEMON_BIGGER)
	set_silhouette(game.CODEMON_BIGGER, $beach/hbox_codemon/bigger)
	
	$beach/equal.text = get_status(game.CODEMON_EQUAL)
	set_silhouette(game.CODEMON_EQUAL, $beach/hbox_codemon/equal)
	
	$beach/nott.text = get_status(game.CODEMON_NOTT)
	set_silhouette(game.CODEMON_NOTT, $beach/hbox_codemon/nott)
	
	$beach/andd.text = get_status(game.CODEMON_ANDD)
	set_silhouette(game.CODEMON_ANDD, $beach/hbox_codemon/andd)
	
	$beach/orr.text = get_status(game.CODEMON_ORR)
	set_silhouette(game.CODEMON_ORR, $beach/hbox_codemon/orr)
	
	
func config_desert_statistic() -> void:
	$desert/if.text = get_status(game.CODEMON_IF)
	set_silhouette(game.CODEMON_IF, $desert/hbox_codemon/if)
	
	$desert/else.text = get_status(game.CODEMON_ELSE)
	set_silhouette(game.CODEMON_ELSE, $desert/hbox_codemon/else)
	
	$desert/for.text = get_status(game.CODEMON_FOR)
	set_silhouette(game.CODEMON_FOR, $desert/hbox_codemon/for)
	
	$desert/while.text = get_status(game.CODEMON_WHILE)
	set_silhouette(game.CODEMON_WHILE, $desert/hbox_codemon/while)
		
	
func set_silhouette(codemon: String, node: TextureRect) -> void:
	if game.status_challenge[codemon] == 0:
		node.modulate.v = 0
		

func get_status(codemon: String) -> String:
	return String(game.status_challenge[codemon]) + "\n" + String(game.status_capture[codemon])


func config_toggle(btn_name: String) -> void:
	$hbox/btn_1.set_toggle(btn_name == $hbox/btn_1.name)
	$hbox/btn_2.set_toggle(btn_name == $hbox/btn_2.name)
	$hbox/btn_3.set_toggle(btn_name == $hbox/btn_3.name)
	$hbox/btn_4.set_toggle(btn_name == $hbox/btn_4.name)


func config_btn_pressed_map() -> void:
	if game.current_map == game.MAP_MOUNTAIN:
		$hbox/btn_2.grab_focus()
		config_toggle($hbox/btn_2.name)
		_on_btn_2_pressed()
	elif game.current_map == game.MAP_BEACH:
		$hbox/btn_3.grab_focus()
		config_toggle($hbox/btn_3.name)
		_on_btn_3_pressed()
	elif game.current_map == game.MAP_DESERT:
		$hbox/btn_4.grab_focus()
		config_toggle($hbox/btn_4.name)
		_on_btn_4_pressed()
	else:
		$hbox/btn_1.grab_focus()
		config_toggle($hbox/btn_1.name)
		_on_btn_1_pressed()
	

func _on_btn_1_pressed() -> void:
	config_toggle($hbox/btn_1.name)
	$mountain.visible = false
	$beach.visible = false
	$desert.visible = false
	$forest.visible = true


func _on_btn_2_pressed() -> void:
	config_toggle($hbox/btn_2.name)
	$mountain.visible = true
	$beach.visible = false
	$desert.visible = false
	$forest.visible = false


func _on_btn_3_pressed() -> void:
	config_toggle($hbox/btn_3.name)
	$mountain.visible = false
	$beach.visible = true
	$desert.visible = false
	$forest.visible = false


func _on_btn_4_pressed() -> void:
	config_toggle($hbox/btn_4.name)
	$mountain.visible = false
	$beach.visible = false
	$desert.visible = true
	$forest.visible = false


func _on_back_pressed() -> void:
	get_parent().get_node("delay").start(0.2)
	queue_free()

