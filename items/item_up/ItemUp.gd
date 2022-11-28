class_name ItemUp

extends Area2D

const Explosion = preload("explosion/Explosion.tscn")

@export var speed := 30

var disabled := true
var is_open := false
var is_opening := false
var velocity := Vector2(0, speed)

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var closed_sprite := $ClosedSprite as Sprite2D
@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var open_sprite := $OpenSprite as Sprite2D
@onready var screen_size := get_viewport_rect().size
@onready var size := ($ClosedSprite as Sprite2D).texture.get_size()
@onready var status_bar := get_node("/root/Level/StatusBar") as StatusBar


func _process(delta: float):
	if not disabled:
		position += velocity * delta

	if global_position.y + size.y / 2 > status_bar.size.y and disabled:
		collision_shape.disabled = false
		disabled = false

	if global_position.y - size.y / 2 > screen_size.y:
		queue_free()


func explode():
	var explosion := Explosion.instantiate() as ItemUpExplosion

	explosion.position = position

	get_parent().add_child(explosion)

	queue_free()


func open():
	if is_opening or is_open:
		return

	var explosion := Explosion.instantiate() as ItemUpExplosion

	explosion.position = position + Vector2(0, size.y / 4)

	get_parent().add_child(explosion)

	is_opening = true

	animation_player.play("Opening")

	await animation_player.animation_finished

	is_open = true
	is_opening = false
