class_name Bubble

extends "res://enemies/enemy/Enemy.gd"


func _process(delta: float):
	super(delta)

	if scale.y < 1:
		velocity.y += speed * delta

		if velocity.y > speed:
			velocity.y = speed

	if global_position.y > screen_size.y / 2 and scale.y == 1:
		explode()


func fall_apart():
	if scale.y < 0.5:
		return

	for _i in range(0, 4 * scale.y):
		var bubble := duplicate() as Bubble
		var spread := 20 * scale.y

		var rand_position := Vector2(randf_range(-spread, spread), randf_range(-spread, spread))

		bubble.position = position + rand_position
		bubble.scale *= 0.75
		bubble.velocity = Vector2(randf_range(-spread, spread), randf_range(-spread, 0))

		get_parent().call_deferred("add_child", bubble)


func explode():
	super()

	fall_apart()
