extends CanvasLayer

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player.health_changed.connect(_on_health_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeLeftLabel.text = "%d:%02d" % [floor($TimeLeftTimer.time_left / 60), int($TimeLeftTimer.time_left) % 60]

func _on_health_change(change):
	health -= change
	$Healthbar.size.x = health * 8

