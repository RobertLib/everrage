class_name MiniBossHeart

extends Area2D

signal hit

var destroyed := false

@onready var mini_boss := get_node("../..") as MiniBoss


func _on_area_entered(area: Area2D):
	if mini_boss.disabled or destroyed:
		return

	var tween := create_tween()

	tween.tween_property(self, "modulate:a", modulate.a - 0.25, 0.25)

	tween.tween_callback(tween_modulate_a_finished)

	area.queue_free()


func tween_modulate_a_finished():
	if modulate.a <= 0:
		destroyed = true

	emit_signal("hit")
