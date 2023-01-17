extends Area2D

const ROT_SPEED = PI * 4
const LIN_SPEED = 200

var damage = 11

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	look_at(get_global_mouse_position())
	rotation -= PI/4
	$AnimationPlayer.play("Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation += ROT_SPEED * delta
	$CollisionShape2D.rotation += ROT_SPEED * delta
	position += Vector2.ONE.rotated(rotation) * LIN_SPEED * delta


func _on_delete_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("harvest"):
		body.take_damage(damage)

