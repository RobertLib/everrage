extends Node2D

const SnakePart = preload("SnakePart.tscn")

@export var quantity := 10

var direction := 0
var disabled := true

@onready var screen_size := get_viewport_rect().size
@onready var status_bar := get_node("/root/Level/StatusBar") as StatusBar
@onready var timer := $Timer as Timer


func _process(_delta: float):
	if global_position.y > status_bar.size.y and disabled:
		dispatch_snake_part()

		timer.start()

		disabled = false

	change_direction_randomly()


func change_direction_randomly():
	if randf_range(0, 10) > 7:
		var new_direction := randi() % 3 - 1

		while new_direction == direction:
			new_direction = randi() % 3 - 1

		direction = new_direction


func dispatch_snake_part():
	var snake_part := SnakePart.instantiate() as SnakePart
	var snake_parts := get_tree().get_nodes_in_group(name)

	snake_part.add_to_group(name)

	if snake_parts.size() > 0:
		var last_snake_part := snake_parts[-1] as SnakePart
		var new_position := last_snake_part.position

		match direction:
			-1:
				new_position.x -= last_snake_part.size.x
			0:
				new_position.y += last_snake_part.size.y
			1:
				new_position.x += last_snake_part.size.x

		snake_part.position = new_position
	else:
		snake_part.position = position

	snake_part.position.x = ceili(snake_part.position.x)
	snake_part.position.y = ceili(snake_part.position.y)

	get_parent().add_child(snake_part)


func _on_Timer_timeout():
	if quantity > 0:
		quantity -= 1

		dispatch_snake_part()
	else:
		timer.stop()
