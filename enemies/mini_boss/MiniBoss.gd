class_name MiniBoss

extends Node2D

const Explosion = preload("explosion/Explosion.tscn")
const TOTAL_TARGET_CHANGES := 6

@export var speed := 40
@export var value := 100

var disabled := true
var target := Vector2.ZERO
var target_changes := 0
var velocity := Vector2(0, speed)

@onready var background := get_node("/root/Level/Background") as Background
@onready var hearts := $Hearts as Node2D
@onready var screen_size := get_viewport_rect().size
@onready var size := ($Sprite2D as Sprite2D).texture.get_size()


func _ready():
	change_target()

	for heart in hearts.get_children():
		heart.connect("hit", Callable(self, "heart_hit"))


func _process(delta: float):
	if not disabled:
		position += velocity * delta

	if global_position.y > 30 and disabled:
		background.stop_scrolling()
		disabled = false

	if target_changes > TOTAL_TARGET_CHANGES:
		velocity = velocity.lerp(Vector2(0, speed), delta)
	elif global_position.distance_to(target) < 1:
		change_target()
	else:
		velocity = velocity.lerp(global_position.direction_to(target) * speed, delta)

	if global_position.y - size.y / 2 > screen_size.y:
		background.restore_scroll()

		queue_free()


func change_target():
	target_changes += 1

	target = Vector2(
		randf_range(size.x, screen_size.x - size.x),
		randf_range(screen_size.y / 3, screen_size.y - size.y * 2.5)
	)


func explode():
	var explosion := Explosion.instantiate() as MiniBossExplosion

	explosion.position = position

	get_parent().add_child(explosion)

	background.restore_scroll()

	queue_free()


func heart_hit():
	var all_destroyed := true

	for heart in hearts.get_children() as Array[MiniBossHeart]:
		if !heart.destroyed:
			all_destroyed = false
			break

	if all_destroyed:
		explode()
