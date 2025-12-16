extends Control

# Get your Leaderboard ID and API key from https://simpleboards.dev/dashboard
@export var leaderboard_id := "REPLACE_WITH_YOUR_LEADERBOARD_ID"
@export var api_key := "REPLACE_WITH_YOUR_API_KEY"

@export var time_label: Label
@export var score_label: Label
@export var player_name: LineEdit
@export var submit_button: Button
@export var leaderboard: Leaderboard


@onready var simpleboards := $SimpleBoardsApi

var _score := 0
var _time_text := ""
var _is_sending := false
var _is_sent := false


func _ready() -> void:
	if leaderboard_id.begins_with("REPLACE") or api_key.begins_with("REPLACE"):
		push_warning("SimpleBoards is not configured. Set leaderboard_id and api_key in the Inspector.")
		return
	simpleboards.set_api_key(api_key)
	simpleboards.entry_sent.connect(_on_entry_sent)
	simpleboards.request_failed.connect(_on_request_failed)

	visible = false
	_update_submit_ui()


func show_result(time_seconds: float, score: int) -> void:
	visible = true

	_score = score
	_time_text = _format_time(time_seconds)

	time_label.text = _time_text
	score_label.text = str(_score)

	_is_sending = false
	_is_sent = false
	_update_submit_ui()

	leaderboard.get_scores()


func _on_submit_score_button_pressed() -> void:
	if _is_sending or _is_sent:
		return

	_is_sending = true
	_update_submit_ui()

	var name := player_name.text.strip_edges()
	if name.is_empty():
		name = "Anonymous"

	await simpleboards.send_score_without_id(
		leaderboard_id,
		name,
		str(_score),
		_time_text
	)


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


func _on_entry_sent(_entry) -> void:
	_is_sending = false
	_is_sent = true
	_update_submit_ui()
	leaderboard.get_scores()


func _on_request_failed(response_code, body) -> void:
	_is_sending = false
	_is_sent = false
	_update_submit_ui()

	push_warning("SimpleBoards request failed: %s - %s" % [response_code, body])


func _update_submit_ui() -> void:
	if _is_sending:
		submit_button.disabled = true
		submit_button.text = "Submitting..."
		player_name.editable = false
		return

	if _is_sent:
		submit_button.disabled = true
		submit_button.text = "Score saved"
		player_name.editable = false
		return

	submit_button.disabled = false
	submit_button.text = "Submit Score"
	player_name.editable = true


func _format_time(seconds: float) -> String:
	var total_ms := int(seconds * 100.0)
	var minutes := total_ms / 6000
	var secs := (total_ms % 6000) / 100
	var ms := total_ms % 100
	return "%02d:%02d:%02d" % [minutes, secs, ms]
