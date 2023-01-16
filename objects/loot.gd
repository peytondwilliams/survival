extends Area2D

@export var placed = false
@export var item_name = "empty"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_placed():
	return placed

func set_placed(place):
	placed = place
