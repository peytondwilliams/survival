extends StaticBody2D

const WOOD = preload("res://objects/wood.tscn")
var health = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage):
	var prev_health = health
	health -= damage
	$AnimatedSprite2D.frame = int(4 - floor(health/5))

	if (health <= 0):
		#animate tree falling
		$AnimationPlayer.play("die")
		$DeathTimer.start()


func _on_death_timer_timeout():
	var loot = WOOD.instantiate()
	get_parent().add_child(loot)
	loot.position = position
	queue_free()
