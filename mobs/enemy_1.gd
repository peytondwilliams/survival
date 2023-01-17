extends CharacterBody2D

var SPEED = 32.0

var health = 20
var attack = 5

var player_pos = Vector2.ZERO

func init(new_health):
	health = new_health

func _physics_process(delta):
	var pos_diff = player_pos - position
	pos_diff = pos_diff.normalized()

	velocity = pos_diff * SPEED

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()

	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("player"):
			collider.take_damage(attack)

func take_damage(hurt_damage):
	$AudioStreamPlayer.play()
	health -= hurt_damage
	if health <= 0:
		$AnimationPlayer.play("Death")
		SPEED = 0
		$DeathTimer.start()

func receive_player_pos(pos):
	player_pos = pos

func _on_death_timer_timeout():
		queue_free()
