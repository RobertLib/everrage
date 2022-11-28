class_name StatusBar

extends Control

@onready var lives_label := $LivesLabel as Label
@onready var score_label := $ScoreLabel as Label


func _ready():
	var error_code := Global.connect("score_changed", Callable(self, "_on_Global_score_changed"))

	if error_code:
		print(error_code)


func _on_Global_score_changed():
	score_label.text = "Score  %d" % Global.get_score()


func _on_player_lives_changed(lives: int):
	lives_label.text = "Lives  %d" % lives
