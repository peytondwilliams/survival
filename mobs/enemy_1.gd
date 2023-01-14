extends CharacterBody2D

const SPEED = 60.0

var health = 10

func init(new_health):
	health = new_health

func _physics_process(delta):
	var player = Globals.player

	var target_pos = player.position
	var pos_diff = target_pos - position
	pos_diff = pos_diff.normalized()

	velocity = pos_diff * SPEED

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()

func take_damage(hurt_damage):
	health -= hurt_damage
	if health <= 0:
		queue_free()
