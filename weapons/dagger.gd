extends Area2D

const ROT_SPEED = PI * 1.5


var damage = 5
var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	rotation += PI/2
	$AnimationPlayer.play("Attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		rotation += ROT_SPEED * delta


func _on_delete_timer_timeout():
	queue_free()


func _on_stop_move_timer_timeout():
	moving = false


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(damage)
