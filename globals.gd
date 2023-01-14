extends Node


var player_scene = preload("res://player/player.tscn")
var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
		player = player_scene.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
