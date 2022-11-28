class_name EnemyBullet

extends Area2D

@export var speed := 100

var velocity := Vector2(1, 0)

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var sprite := $Sprite2D as Sprite2D


func _process(delta: float):
	position += velocity.rotated(rotation) * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area: Area2D):
	if area is Player:
		var player := area as Player

		if not player.immortality:
			player.explode()

			queue_free()
