extends "res://enemies/enemy/Enemy.gd"

const TOTAL_TARGET_CHANGES := 3

var target := Vector2.ZERO
var target_changes := 0

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready():
	animation_player.play("Spin")

	change_target()


func _process(delta: float):
	super(delta)

	if global_position.y > 20:
		velocity = global_position.direction_to(target) * speed

	if target_changes > TOTAL_TARGET_CHANGES:
		velocity = Vector2(0, speed)
	elif global_position.distance_to(target) < 1:
		change_target()


func change_target():
	target_changes += 1

	target = Vector2(
		randf_range(size.x, screen_size.x - size.x),
		randf_range(screen_size.y / 3, screen_size.y - size.y)
	)
