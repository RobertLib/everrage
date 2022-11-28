class_name PlayerMissile

extends Area2D

@export var speed := 200

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var sprite := $Sprite2D as Sprite2D


func _process(delta: float):
	position.y -= speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Missile_area_entered(area: Area2D):
	if area is ItemUp:
		var item_up := area as ItemUp

		if item_up.is_open:
			item_up.explode()
		else:
			item_up.open()

		queue_free()

	if area is Enemy:
		var enemy := area as Enemy

		Global.add_score(enemy.value)

		enemy.explode()

		queue_free()
