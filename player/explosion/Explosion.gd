class_name PlayerExplosion

extends Node2D

@onready var animated_sprite := $AnimatedSprite2D as AnimatedSprite2D


func _ready():
	animated_sprite.play()

	GlobalCamera.shake_screen()


func _on_AnimatedSprite_animation_finished():
	queue_free()
