extends Node2D
class_name Spawner

@export var obstacle_scene: PackedScene

func spawn() -> void:
	if obstacle_scene == null:
		return

	var obstacle := obstacle_scene.instantiate()
	add_child(obstacle)
