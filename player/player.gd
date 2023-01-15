extends CharacterBody2D

signal health_changed(change)
signal inventory_changed(inv)

const SPEED = 100.0
const SPEAR = preload("res://weapons/spear.tscn")
const DAGGER = preload("res://weapons/dagger.tscn")
const INVENTORY_MAX = 3

var nearby_loot = []
var nearby_loot_count = 0

var inventory = {
	"wood": 0,
	"stone": 0,
	"ore": 0
}


var health = 100

func _physics_process(delta):
	var horz_dir = Input.get_axis("action_left", "action_right")
	var vert_dir = Input.get_axis("action_up", "action_down")

	velocity.x = horz_dir
	velocity.y = vert_dir

	velocity = velocity.normalized() * SPEED

	if horz_dir:
		$AnimatedSprite2D.animation = "horz"
		if horz_dir > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif vert_dir:
		if vert_dir > 0:
			$AnimatedSprite2D.animation = "down"
		else:
			$AnimatedSprite2D.animation = "up"
	else:
		$AnimatedSprite2D.animation = "idle"

	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("action_spear") and $AttackCooldown.is_stopped():
		$AttackCooldown.start()
		#var spear = SPEAR.instantiate()
		var dagger = DAGGER.instantiate()
		#add_child(spear)
		add_child(dagger)

	if Input.is_action_just_pressed("action_loot") and nearby_loot.size() > 0:
		pickup()

	move_and_slide()

func pickup():
	var closest_loot = nearby_loot[0]
	var closest_loot_mag = (position - closest_loot.position).length()
	for loot in nearby_loot:
		var loot_mag = (position - loot.position).length()
		if loot_mag < closest_loot_mag:
			closest_loot = loot
			closest_loot_mag = loot_mag

	for loot in ["wood", "stone", "ore"]:
		if closest_loot.is_in_group(loot) and inventory[loot] < INVENTORY_MAX:
		# play sound effect
			inventory[loot] += 1
			closest_loot.queue_free()
			inventory_update()
			break


func take_damage(hurt_damage):
	if $IFrameTimer.is_stopped():
		$IFrameTimer.start()
		health -= hurt_damage
		emit_signal("health_changed", hurt_damage)

func inventory_update():
	emit_signal("inventory_changed", inventory)

func _on_heal_timer_timeout():
	if health < 100:
		health += 1
		emit_signal("health_changed", -1)


func _on_pickup_area_area_entered(area):
	if area.is_in_group("Loot"):
		nearby_loot.append(area)


func _on_pickup_area_area_exited(area):
	if area.is_in_group("Loot"):
		var i = 0
		for loot in nearby_loot:
			if area == loot:
				nearby_loot.pop_at(i)
			i += 1
