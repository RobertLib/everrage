class_name TransitionsSquare

extends Node2D

var size := 16


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
