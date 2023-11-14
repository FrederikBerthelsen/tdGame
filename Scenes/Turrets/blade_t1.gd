extends Node2D

func _physics_process(delta):
	turn()
	
func turn():
	get_node("Blade").rotate(0.2)
