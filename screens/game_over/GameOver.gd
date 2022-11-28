extends Control


func _process(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		Transitions.change_scene_to_file("res://screens/splash/Splash.tscn")

		Global.reset()
