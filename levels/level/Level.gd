extends Node2D

@onready var player := $Player as Player
@onready var ready_label := $UI/ReadyLabel as Label
@onready var status_bar := $StatusBar as StatusBar


func _ready():
	var error_code := player.connect(
		"lives_changed", Callable(status_bar, "_on_player_lives_changed")
	)

	if error_code:
		print(error_code)


func _on_ReadyTimer_timeout():
	ready_label.hide()
