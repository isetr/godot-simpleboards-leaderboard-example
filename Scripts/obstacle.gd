extends AnimatableBody2D

@export var fall_speed := 250.0


func _physics_process(delta: float) -> void:
	global_position.y += fall_speed * delta

	if global_position.y > get_viewport_rect().size.y + 50:
		queue_free()
