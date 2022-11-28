extends Camera2D

var screen_is_shaking := false

@onready var screen_shake_timer := $ScreenShakeTimer as Timer


func _process(_delta: float):
	if screen_is_shaking:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	else:
		offset = Vector2.ZERO


func shake_screen():
	screen_is_shaking = true

	screen_shake_timer.start()


func _on_ScreenShakeTimer_timeout():
	screen_is_shaking = false
