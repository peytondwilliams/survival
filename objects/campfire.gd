extends StaticBody2D

signal extinguish

const WOOD_ENERGY_VAL = 0.4
const WOOD_SCALE_VAL = 0.3
const AREA_FACTOR = 0.7

var wood = 12
var ring_rad = 265

var color = Color(Color.DARK_GOLDENROD)

# energy = 4
# scale = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	color.a = 0.1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PointLight2D.texture_scale -= WOOD_SCALE_VAL / 30 * delta
	#$PointLight2D.energy -= WOOD_ENERGY_VAL / 30 * delta
	$LitArea.scale -= Vector2(1, 1).normalized() * AREA_FACTOR * WOOD_SCALE_VAL / 30 * delta
	ring_rad -= 175 * AREA_FACTOR * WOOD_SCALE_VAL / 30 * delta
#	queue_redraw()

#func _draw():
#	draw_arc(Vector2.ZERO, ring_rad, 0, TAU, 50, Color.DARK_GOLDENROD, 1)

func add_wood():
	wood += 1
	$PointLight2D.texture_scale += WOOD_SCALE_VAL
	#$PointLight2D.energy += WOOD_ENERGY_VAL
	$LitArea.scale += Vector2(1, 1).normalized() * WOOD_SCALE_VAL * AREA_FACTOR * 0.9
	ring_rad += 175 * AREA_FACTOR * WOOD_SCALE_VAL


func _on_wood_burn_timer_timeout():
	wood -= 1
	if (wood <= 0):
		emit_signal("extinguish")

