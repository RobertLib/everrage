class_name MiniBossBarrel

extends Node2D

const Bullet = preload("bullet/Bullet.tscn")

@onready var mini_boss := get_node("../..") as MiniBoss
@onready var shot_timer := $ShotTimer as Timer
@onready var target := $Target as Marker2D


func _process(delta: float):
	if not mini_boss.disabled:
		if randf_range(0, 0.5) < delta:
			shoot()


func shoot():
	if shot_timer.is_stopped():
		shot_timer.start()
	else:
		return

	var bullet := Bullet.instantiate() as MiniBossBullet

	bullet.position = position + target.position

	get_parent().add_child(bullet)
