extends Area2D

const SPEED = 100

var damage = 20
var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	look_at(get_global_mouse_position())
	rotation += PI/2
	$AnimationPlayer.play("Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if moving:
		position += Vector2.ONE.rotated(rotation - 3* PI /4) * SPEED * delta


func _on_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("harvest"):
		body.take_damage(damage)


func _on_delete_timer_timeout():
	queue_free()


func _on_stop_move_timer_timeout():
	moving = false # Replace with function body.
