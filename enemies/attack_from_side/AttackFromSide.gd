extends "res://enemies/enemy/Enemy.gd"


func _process(delta: float):
	super(delta)

	if disabled:
		return

	if global_position.y >= player.position.y - player.size.y / 2 and velocity.x == 0:
		if global_position.x > player.position.x:
			velocity = Vector2(-speed * 2, 0)
		else:
			velocity = Vector2(speed * 2, 0)
