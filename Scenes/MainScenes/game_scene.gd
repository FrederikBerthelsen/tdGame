extends Node2D

var map_node 

var build_mode = false
var build_valid = false
var new_round = true
var map_updated = false
var astar_grid: AStarGrid2D
var astar_path: PackedVector2Array
var build_tile
var build_location
var build_type
var start_map



# Called when the node enters the scene tree for the first time.
func _ready():
	map_node = get_node("Map1")
	
	start_map = map_node.get_node("Ground")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(self.initate_build_mode.bind(i.get_name()))
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = map_node.get_node("Ground").get_used_rect()
	astar_grid.cell_size = Vector2(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_pos = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_pos = Vector2(
				x + region_pos.x,
				y + region_pos.y
			)
			
			var tile_data1 = map_node.get_node("TowerExclusion").get_cell_tile_data(0, tile_pos)
			var tile_data2 = map_node.get_node("Ground").get_cell_tile_data(0, tile_pos)
			
			astar_grid.set_point_solid(Vector2(17,0))
			if tile_data2 == null or not (tile_data1 == null):
				astar_grid.set_point_solid(tile_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if build_mode:
		self.update_tower_preview()
	if new_round or map_updated:
		self.update_path()


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

func update_tiles_on_build(tile):
	for x in [0,1]:
		for y in [0,1]:
			astar_grid.set_point_solid(build_tile + Vector2i(x,y))
	
	

func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 3, Vector2i(42,12))
		update_tiles_on_build(build_tile)
		clear_path()
		astar_path = astar_grid.get_point_path(Vector2(17,-2), Vector2(17,23))
		draw_path()
		return true
	return false

func clear_path():
	map_node.get_node("Ground").clear_layer(1)

func draw_path():
	for point in astar_path:
		var point_tile = map_node.get_node("Ground").local_to_map(point)
		print(point_tile)
		map_node.get_node("Ground").set_cell(1, point_tile, 0, Vector2i(0,4))
		

func update_path():
	return
