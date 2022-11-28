extends "res://enemies/enemy/Enemy.gd"

@onready var barrel := $Barrel as Node2D


func _ready():
	velocity = Vector2.ZERO


func _process(delta: float):
	super(delta)

	barrel.rotation = lerp_angle(barrel.rotation, get_angle_to(player.position), 0.05)


func shoot():
	var bullet := super()

	if bullet:
		bullet.rotation = barrel.rotation
