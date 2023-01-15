extends StaticBody2D

signal extinguish

const WOOD_ENERGY_VAL = 0.4
const WOOD_SCALE_VAL = 0.2

var wood = 10
# energy = 4
# scale = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PointLight2D.texture_scale -= WOOD_SCALE_VAL / 20 * delta
	$PointLight2D.energy -= WOOD_ENERGY_VAL / 20 * delta

func add_wood():
	wood += 1
	$PointLight2D.texture_scale += WOOD_SCALE_VAL
	$PointLight2D.energy += WOOD_ENERGY_VAL


func _on_wood_burn_timer_timeout():
	wood -= 1
	if (wood <= 0):
		emit_signal("extinguish")

