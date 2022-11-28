extends Control


func _process(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		Transitions.change_scene_to_file(
			"res://levels/level_1/Level.tscn", Transitions.Types.SQUARES
		)
