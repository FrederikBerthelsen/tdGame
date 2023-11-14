extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func set_tower_preview(tower_type, mouse_pos):
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("54ff3c", 0.5)
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2i(16,16)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://assets/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ffffff", 1.0)

	var control = Control.new()
	control.add_child(drag_tower, true)
	
	control.add_child(range_texture, true)
	
	control.position = mouse_pos
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	
func update_tower_preview(new_position, color1, color2, alpha):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color1, alpha):
		get_node("TowerPreview/DragTower").modulate = Color(color1, alpha)
		get_node("TowerPreview/Sprite2D").modulate = Color(color2, 1.0)
