extends "res://enemies/enemy/Enemy.gd"

var timer := 0.0


func _process(delta: float):
	super(delta)

	timer += delta * 3

	velocity = Vector2(sin(timer) * 50, speed)
