extends CharacterBody2D
class_name Player

signal hit_obstacle(obstacle: Node)

@export var position_left: Marker2D
@export var position_middle: Marker2D
@export var position_right: Marker2D

@export var move_speed := 12.0

var lanes: Array[Vector2]
var current_lane := 1
var is_game_over := false

func _ready() -> void:
	lanes = [
		position_left.global_position,
		position_middle.global_position,
		position_right.global_position
	]

	global_position = lanes[current_lane]

	$Hitbox.area_entered.connect(_on_hitbox_area_entered)


func _physics_process(delta: float) -> void:
	if is_game_over:
		return
	
	if Input.is_action_just_pressed("ui_left"):
		current_lane = max(current_lane - 1, 0)

	if Input.is_action_just_pressed("ui_right"):
		current_lane = min(current_lane + 1, lanes.size() - 1)

	global_position = global_position.lerp(
		lanes[current_lane],
		move_speed * delta
	)

func game_over() -> void:
	is_game_over = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	emit_signal("hit_obstacle", area.get_parent())
