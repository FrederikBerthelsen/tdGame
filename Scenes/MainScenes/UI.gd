extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func set_tower_preview(tower_type, mouse_pos):
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("54ff3c", 0.5)
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_pos
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	
func update_tower_preview(new_position, color, alpha):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color, alpha):
		get_node("TowerPreview/DragTower").modulate = Color(color, alpha)
