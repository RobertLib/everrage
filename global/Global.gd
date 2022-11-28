extends Node

signal score_changed

var _score := 0


func add_score(value: int):
	_score += value

	emit_signal("score_changed")


func get_score() -> int:
	return _score


func reset():
	_score = 0
