class_name Player

extends Area2D

signal lives_changed(lives)

enum States { ALIVE, DEAD }

const Bullet = preload("bullet/Bullet.tscn")
const Explosion = preload("explosion/Explosion.tscn")
const Missile = preload("turret/missile/Missile.tscn")
const Turret = preload("turret/Turret.tscn")

@export var speed := 75.0

var can_shoot := true
var immortality := false
var left_turret: PlayerTurret = null
var lives := 3
var right_turret: PlayerTurret = null
var shields := 0
var state := States.ALIVE
var turrets_level := 0
var weapons_level := 1

@onready var bullet_audio := $Audio/BulletAudio as AudioStreamPlayer2D
@onready var immortality_timer := $ImmortalityTimer as Timer
@onready var item_up_audio := $Audio/ItemUpAudio as AudioStreamPlayer2D
@onready var number_of_weapon_upgrades := $ShotPositions.get_children().size()
@onready var orbs := $Orbs as Node2D
@onready var screen_size := get_viewport_rect().size
@onready var size := ($Sprite2D as Sprite2D).texture.get_size()
@onready var shot_positions := $ShotPositions as Node2D
@onready var shot_timer := $ShotTimer as Timer


func _ready():
	to_dead()


func _process(delta: float):
	match state:
		States.ALIVE:
			alive_process(delta)
		States.DEAD:
			dead_process(delta)

	if immortality:
		modulate.a = 0.5 if Engine.get_frames_drawn() % 20 > 10 else 1.0
	else:
		modulate.a = 1.0

	orbs.rotate(delta * 4)

	if left_turret:
		left_turret.position = left_turret.position.lerp(position + Vector2(-12, 1), 40 * delta)

	if right_turret:
		right_turret.position = right_turret.position.lerp(position + Vector2(12, 1), 40 * delta)


func alive_process(delta: float):
	var velocity := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_accept"):
		shoot()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	position.x = clampf(position.x, size.x / 2, screen_size.x - size.x / 2)
	position.y = clampf(position.y, size.y / 2, screen_size.y - size.y / 2)


func begin_immortality():
	immortality_timer.start()

	immortality = true


func end_immortality():
	immortality = false


func to_dead():
	begin_immortality()

	position.y = screen_size.y + size.y

	state = States.DEAD


func dead_process(delta: float):
	position.y -= speed * delta

	if position.y <= 125:
		state = States.ALIVE


func raise_shield():
	if shields >= 0 and shields < orbs.get_child_count():
		for orb in orbs.get_children() as Array[Node2D]:
			orb.hide()

		shields += 1

		(orbs.get_node(str(shields)) as Node2D).show()


func lower_shield():
	if shields > 0:
		for orb in orbs.get_children() as Array[Node2D]:
			orb.hide()

		shields -= 1

		if shields > 0:
			(orbs.get_node(str(shields)) as Node2D).show()


func shoot():
	if can_shoot:
		shot_timer.start()

		can_shoot = false

		for shot_position in (
			shot_positions.get_node(str(weapons_level)).get_children() as Array[Marker2D]
		):
			var bullet := Bullet.instantiate() as PlayerBullet

			bullet.position = shot_position.global_position
			bullet.rotation = shot_position.rotation

			get_parent().add_child(bullet)

		if left_turret:
			var missile := Missile.instantiate() as PlayerMissile

			missile.position = left_turret.position

			get_parent().add_child(missile)

		if right_turret:
			var missile := Missile.instantiate() as PlayerMissile

			missile.position = right_turret.position

			get_parent().add_child(missile)

		bullet_audio.play()


func subtract_life():
	if lives > 0:
		lives -= 1

		emit_signal("lives_changed", lives)
	else:
		Transitions.change_scene_to_file("res://screens/game_over/GameOver.tscn")


func upgrade_turret():
	if turrets_level >= 2:
		return

	turrets_level += 1

	if turrets_level == 1:
		left_turret = Turret.instantiate() as PlayerTurret
		left_turret.position = position

		get_node("../..").call_deferred("add_child", left_turret)
	elif turrets_level == 2:
		right_turret = Turret.instantiate() as PlayerTurret
		right_turret.position = position

		get_node("../..").call_deferred("add_child", right_turret)


func downgrade_turrets():
	turrets_level = 0

	if left_turret:
		left_turret.queue_free()
		left_turret = null

	if right_turret:
		right_turret.queue_free()
		right_turret = null


func upgrade_weapons():
	if weapons_level < number_of_weapon_upgrades:
		weapons_level += 1


func explode():
	downgrade_turrets()
	downgrade_weapons()

	subtract_life()

	to_dead()

	var explosion := Explosion.instantiate() as PlayerExplosion

	explosion.position = position

	get_parent().add_child(explosion)


func downgrade_weapons():
	weapons_level = 1


func _on_ImmortalityTimer_timeout():
	end_immortality()


func _on_ShotTimer_timeout():
	shot_timer.stop()

	can_shoot = true


func _on_Player_area_entered(area: Area2D):
	if area is MissileUp:
		upgrade_turret()

	if area is PowerUp:
		upgrade_weapons()

	if area is ShieldUp:
		raise_shield()

	if area is SpeedUp:
		speed *= 1.25

	if area is ItemUp:
		var item_up := area as ItemUp

		if item_up.is_opening or item_up.is_open:
			item_up_audio.play()

			item_up.queue_free()

			return

		item_up.explode()

	if immortality:
		return

	if area is Enemy:
		(area as Enemy).explode()

	if shields > 0:
		lower_shield()

		begin_immortality()
	else:
		explode()
