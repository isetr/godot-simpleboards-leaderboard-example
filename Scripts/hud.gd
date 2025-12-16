extends CanvasLayer
class_name HUD

@export var time_value: Label
@export var score_value: Label

@onready var game_over_panel := $GameOver

var _elapsed_seconds := 0.0
var _score := 0


func set_time(seconds: float) -> void:
	_elapsed_seconds = seconds
	time_value.text = _format_time(seconds)


func set_score(score: int) -> void:
	_score = score
	score_value.text = str(score)


func game_over() -> void:
	game_over_panel.show_result(_elapsed_seconds, _score)


func _format_time(seconds: float) -> String:
	var total_ms := int(seconds * 100.0)
	var minutes := total_ms / 6000
	var secs := (total_ms % 6000) / 100
	var ms := total_ms % 100
	return "%02d:%02d:%02d" % [minutes, secs, ms]
