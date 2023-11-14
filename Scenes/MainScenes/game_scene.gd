extends Node2D

var map_node 

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type


# Called when the node enters the scene tree for the first time.
func _ready():
	map_node = get_node("Map1")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(self.initate_build_mode.bind(i.get_name()))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if build_mode:
		self.update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		if verify_and_build():
			cancel_build_mode()


func initate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "_t1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func all_cells_free(map, layer, tile):
	var res = true
	for x in [-1,0,1]:
		for y in [-1, 0, 1]:
			res = res and (map_node.get_node(map).get_cell_source_id(layer, tile + Vector2i(x,y)) == -1)
	return res

func update_tower_preview():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var mouse_pos = get_global_mouse_position()
	var curr_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_pos)
	var tile_pos = map_node.get_node("TowerExclusion").map_to_local(curr_tile)

	
	if all_cells_free("TowerExclusion", 0, curr_tile):
#	if map_node.get_node("TowerExclusion").get_cell_source_id(0, curr_tile) == -1:
		get_node("UI").update_tower_preview(tile_pos, "54ff3c", "ffffff", 0.5)
		build_valid = true
		build_location = tile_pos
		build_tile = curr_tile
	else:
		get_node("UI").update_tower_preview(tile_pos, "ff4545", "ff4545", 0.5)
		build_valid = false


func cancel_build_mode():
	build_mode = false
	build_valid = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_node("UI/TowerPreview").free()


func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 3, Vector2i(42,12))
		return true
	return false


