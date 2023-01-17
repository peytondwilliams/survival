extends Area2D

const ROT_SPEED = PI * 1.5

var damage = 15
var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	look_at(get_global_mouse_position())
	rotation += PI/3
	$AnimationPlayer.play("Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		rotation += ROT_SPEED * delta


func _on_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("harvest"):
		body.take_damage(damage)



func _on_deletetimer_timeout():
	queue_free()


func _on_move_timer_timeout():
	moving = false
