extends Node2D

var astar_grid: AStarGrid2D
var astar_path: PackedVector2Array
var map_node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_node = get_node("/root/SceneHandler/GameScene")
	
	astar_grid = map_node.astar_grid


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_path()
	move()
	pass

func update_path():
	astar_grid = map_node.astar_grid
	astar_path = astar_grid.get_point_path(
		map_node.get_node("Map1/Ground").local_to_map(global_position), 
		Vector2(17,23)
		)
	astar_path.remove_at(0)
	
func move():
	var dest = Vector2i(astar_path[0].x, astar_path[0].y) + Vector2i(16,16)
	self.global_position = self.global_position.move_toward(dest, 0.5)
	self.look_at(dest)
	
