extends "res://enemies/enemy/Enemy.gd"


func _process(delta: float):
	super(delta)

	if disabled:
		return

	rotate(delta)
