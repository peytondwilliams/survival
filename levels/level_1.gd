extends Node2D

signal game_over()

const enemy_1 = preload("res://mobs/enemy_1.tscn")
const enemy_2 = preload("res://mobs/enemy_2.tscn")
# Called when the node enters the scene tree for the first time.'

var enemy_health = 15
var minutes = 0

func _ready():
	$GuideAnimation.play("Fade")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout():
	var new_enemy = enemy_1.instantiate()
	new_enemy.init(enemy_health) #health value
	add_child(new_enemy)
	$Player.current_pos.connect(new_enemy.receive_player_pos)

	var spawn_pos = random_spawn_pos()
	new_enemy.position = spawn_pos


func random_spawn_pos():
	var vert_or_horz = bool(randi_range(0, 1))
	var side = randi_range(0, 1)
	if side == 0:
		side = -1

	var spawn_pos = Vector2.ZERO

	if(vert_or_horz):
		spawn_pos = Vector2($Player.position.x + side * 450, $Player.position.y + randi_range(-250, 250))
	else:
		spawn_pos = Vector2($Player.position.x + randi_range(-450, 450), $Player.position.y + side * 250)

	return spawn_pos

func _on_campfire_extinguish():
	#lose games
	pass # Replace with function body.


func _on_minute_timer_timeout():
	enemy_health += 3
	minutes += 1

	if minutes <= 5:
		$SpawnTimer.wait_time -= 0.15
	else:
		$BigSpawnTimer.wait_time -= 0.15
	if minutes == 5:
		$BigSpawnTimer.start()



func _on_big_spawn_timer_timeout():
	var new_enemy = enemy_2.instantiate()
	new_enemy.init(enemy_health * 2) #health value
	add_child(new_enemy)
	$Player.current_pos.connect(new_enemy.receive_player_pos)

	var spawn_pos = random_spawn_pos()
	new_enemy.position = spawn_pos





func _on_player_die():
	#emite signal to main menu
	emit_signal("game_over")
	pass # Replace with function body.
