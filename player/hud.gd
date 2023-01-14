extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeLeftLabel.text = "%d:%02d" % [floor($TimeLeftTimer.time_left / 60), int($TimeLeftTimer.time_left) % 60]
