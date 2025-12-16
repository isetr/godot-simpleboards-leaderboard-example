extends Node2D

@export var player: Player
@export var spawners: Array[Spawner]

@export var start_interval := 2.0
@export var min_interval := 0.4
@export var interval_decrease := 0.1
@export var difficulty_step_time := 3.0

@onready var hud := $Hud
@onready var score_box := $ScoreBox

var _spawn_timer: Timer
var _difficulty_timer: Timer

var _score := 0
var _elapsed_time := 0.0
var _is_running := true


func _ready() -> void:
	_reset_run_state()
	_bind_signals()
	_create_timers()
	_start_timers()


func _process(delta: float) -> void:
	if not _is_running:
		return

	_elapsed_time += delta
	hud.set_score(_score)
	hud.set_time(_elapsed_time)


func _bind_signals() -> void:
	player.hit_obstacle.connect(_on_player_hit)
	score_box.area_entered.connect(_on_score_box_entered)


func _create_timers() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(_spawn_timer)

	_difficulty_timer = Timer.new()
	_difficulty_timer.one_shot = false
	_difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	add_child(_difficulty_timer)


func _start_timers() -> void:
	_spawn_timer.wait_time = start_interval
	_spawn_timer.start()

	_difficulty_timer.wait_time = difficulty_step_time
	_difficulty_timer.start()


func _reset_run_state() -> void:
	_score = 0
	_elapsed_time = 0.0
	_is_running = true


func _on_spawn_timer_timeout() -> void:
	if not _is_running:
		return
	if spawners.is_empty():
		return

	spawners.pick_random().spawn()


func _on_difficulty_timer_timeout() -> void:
	if not _is_running:
		return

	_spawn_timer.wait_time = max(_spawn_timer.wait_time - interval_decrease, min_interval)


func _on_score_box_entered(_area: Area2D) -> void:
	if not _is_running:
		return

	_score += 1


func _on_player_hit(_obstacle: Node) -> void:
	_set_game_over()


func _set_game_over() -> void:
	if not _is_running:
		return

	_is_running = false
	_spawn_timer.stop()
	_difficulty_timer.stop()

	hud.game_over()
	player.game_over()
