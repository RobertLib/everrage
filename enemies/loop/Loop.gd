extends "res://enemies/enemy/Enemy.gd"

var angle := PI
var direction := 0
var radius := 80


func _ready():
	direction = 1 if position.x / screen_size.x > 0.5 else -1


func _process(delta: float):
	super(delta)

	if disabled:
		return

	if angle > -8:
		angle -= PI * delta

	position.x += sin(angle * direction) * radius * delta
	position.y += cos(angle * direction) * radius * delta
