class_name Enemy

extends Area2D

const Bullet = preload("bullet/Bullet.tscn")
const Explosion = preload("explosion/Explosion.tscn")

@export var bullet_rotation := PI / 2
@export var can_shoot := false
@export var speed := 40
@export var value := 100

var disabled := true
var velocity := Vector2(0, speed)

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var player := get_node("/root/Level/Player") as Player
@onready var screen_size := get_viewport_rect().size
@onready var shot_timer := $ShotTimer as Timer
@onready var size := ($Sprite2D as Sprite2D).texture.get_size()
@onready var status_bar := get_node("/root/Level/StatusBar") as StatusBar


func _process(delta: float):
	if not disabled:
		position += velocity * delta

		if randf_range(0, 0.5) < delta:
			shoot()

	if global_position.y + size.y / 2 > status_bar.size.y and disabled:
		collision_shape.disabled = false
		disabled = false

	if global_position.y - size.y / 2 > screen_size.y:
		queue_free()


func explode():
	var explosion := Explosion.instantiate() as EnemyExplosion

	explosion.position = position

	get_parent().add_child(explosion)

	queue_free()


func shoot() -> EnemyBullet:
	if not can_shoot:
		return

	if shot_timer.is_stopped():
		shot_timer.start()
	else:
		return

	var bullet := Bullet.instantiate() as EnemyBullet

	bullet.position = position
	bullet.rotation = bullet_rotation
	bullet.scale = scale

	get_parent().add_child(bullet)

	return bullet
