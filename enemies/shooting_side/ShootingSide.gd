extends "res://enemies/enemy/Enemy.gd"

@onready var background := get_node("/root/Level/Background") as Background


func _ready():
	velocity = Vector2.ZERO


func _process(delta: float):
	super(delta)

	position.y -= background.border_speed * delta
