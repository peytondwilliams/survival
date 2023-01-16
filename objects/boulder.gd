extends StaticBody2D

const STONE = preload("res://objects/stone.tscn")
const ORE = preload("res://objects/ore.tscn")
var health = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage):
	$AudioStreamPlayer.play()
	var prev_health = health
	health -= damage
	$AnimatedSprite2D.frame = int(3 - floor(health/7))

	if (health <= 0):
		#animate tree falling
		$AnimationPlayer.play("die")
		$DeathTimer.start()


func _on_death_timer_timeout():
	var loot = STONE.instantiate()
	get_parent().add_child(loot)
	loot.position = position

	if randi_range(0, 9) < 3:
		var ore = ORE.instantiate()
		get_parent().add_child(ore)
		ore.position = position + Vector2(18, 0)
	queue_free()
