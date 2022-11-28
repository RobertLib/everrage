class_name Background

extends Node2D

@export var speed := 10
@export var player_node_path: NodePath

var original_speed := speed

var border_speed := 0.0:
	set(value):
		border_speed = value
	get:
		return speed / 4.0

var starfield_speed := 0.0:
	set(value):
		starfield_speed = value
	get:
		return speed / 2.0

@onready var border := $Border as TileMap
@onready var player := get_node(player_node_path) as Player
@onready var screen_size := get_viewport_rect().size
@onready var starfield := $Starfield as TileMap


func _process(delta: float):
	position.x = (player.position.x - screen_size.x / 2) / 25
	position.y += speed * delta

	border.position.y -= border_speed * delta
	starfield.position.y -= starfield_speed * delta


func stop_scrolling():
	speed = 0


func restore_scroll():
	speed = original_speed
