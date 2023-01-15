extends CharacterBody2D

signal health_changed(change)
signal inventory_changed(inv)
signal selected_loot_changed(loot_sel)

const SPEED = 100.0
const SPEAR = preload("res://weapons/spear.tscn")
const DAGGER = preload("res://weapons/dagger.tscn")

const INGOT = preload("res://objects/ore.tscn")
const INVENTORY_MAX = 3

var nearby_loot = []
var nearby_loot_count = 0

var nearby_fire = null

var inventory = {
	"wood": 0,
	"stone": 0,
	"ore": 0,
	"ingot": 0
}

var selected_loot = "wood"

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

	if Input.is_action_pressed("action_spear") and $AttackCooldown.is_stopped():
		$AttackCooldown.start()
		#var spear = SPEAR.instantiate()
		var dagger = DAGGER.instantiate()
		#add_child(spear)
		add_child(dagger)

	if Input.is_action_just_pressed("action_loot") and nearby_loot.size() > 0:
		pickup()

	if Input.is_action_just_pressed("action_interact") and nearby_fire != null:
		add_to_fire()

	if Input.is_action_just_pressed("action_item_scroll"):
		scroll()

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

func add_to_fire():
	if selected_loot == "wood" and inventory["wood"] > 0:
		nearby_fire.add_wood()
		inventory["wood"] -= 1
	elif selected_loot == "stone" and inventory["stone"] > 0:
		$GlowLight.enabled = true
		$AnimationPlayer.play("glow_reduce")
		inventory["stone"] -= 1
		$GlowTimer.start()
	elif selected_loot == "ore" and inventory["ore"] > 0:
		inventory["ore"] -= 1
		var ingot = INGOT.instantiate()
		get_parent().add_child(ingot)
		ingot.position = position
	# INGOT add to fire?
	inventory_update() #


func scroll():
	if selected_loot == "wood":
		selected_loot = "stone"
	elif selected_loot == "stone":
		selected_loot = "ore"
	elif selected_loot == "ore":
		selected_loot = "ingot"
	elif selected_loot == "ingot":
		selected_loot = "wood"
	emit_signal("selected_loot_changed", selected_loot)

func _on_heal_timer_timeout():
	if health < 100:
		health += 1
		emit_signal("health_changed", -1)


func _on_pickup_area_area_entered(area):
	print("entered")
	if area.is_in_group("Loot"):
		nearby_loot.append(area)



func _on_pickup_area_area_exited(area):
	if area.is_in_group("Loot"):
		var i = 0
		for loot in nearby_loot:
			if area == loot:
				nearby_loot.pop_at(i)
			i += 1



func _on_pickup_area_body_entered(body):
	if body.is_in_group("fire"):
		nearby_fire = body


func _on_pickup_area_body_exited(body):
	if body.is_in_group("fire"):
		nearby_fire = null


func _on_glow_timer_timeout():
	$GlowLight.enabled = false
