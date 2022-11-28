class_name MiniBossBullet

extends Area2D

@export var speed := 100


func _process(delta: float):
	position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area: Area2D):
	if area is Player:
		var player := area as Player

		if not player.immortality:
			player.explode()

			queue_free()
