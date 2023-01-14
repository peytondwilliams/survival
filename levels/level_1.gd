extends Node2D

var enemy_1 = preload("res://mobs/enemy_1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Globals.player)
	Globals.player.position = Vector2(600, 300)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout():
	var new_enemy = enemy_1.instantiate(10)
	new_enemy.init(10) #health value
	add_child(new_enemy)

	var vert_or_horz = bool(randi_range(0, 1))
	var side = randi_range(0, 1)
	if side == 0:
		side = -1

	var spawn_pos = Vector2.ZERO

	if(vert_or_horz):
		spawn_pos = Vector2(Globals.player.position.x + side * 450, Globals.player.position.y + randi_range(-250, 250))
	else:
		spawn_pos = Vector2(Globals.player.position.x + randi_range(-450, 450), Globals.player.position.y + side * 250)

	new_enemy.position = spawn_pos

