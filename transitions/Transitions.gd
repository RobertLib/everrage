extends CanvasLayer

enum Types { DEFAULT, SQUARES }

const Square = preload("square/Square.tscn")

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func change_scene_to_file(path: String, type: Types = Types.DEFAULT):
	animation_player.play("Dissolve")

	if type == Types.SQUARES:
		for y in range(0, 9):
			for x in range(0, 10):
				var square := Square.instantiate() as TransitionsSquare

				square.position = Vector2(
					x * square.size + square.size / 2.0, y * square.size + square.size / 2.0
				)

				add_child(square)

	await animation_player.animation_finished

	var error_code := get_tree().change_scene_to_file(path)

	if error_code:
		print(error_code)

	animation_player.play_backwards("Dissolve")
