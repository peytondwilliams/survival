extends CharacterBody2D

signal health_changed(change)
signal sanity_val(sanity)
signal inventory_changed(inv)
signal selected_loot_changed(loot_sel)
signal current_pos(pos)
signal die()
signal interact(visible)

const SPEED = 85.0

const WEAPON_DICT = {
	"dagger": preload("res://weapons/dagger.tscn"),
	"spear": preload("res://weapons/spear.tscn"),
	"sword": preload("res://weapons/sword.tscn"),
	"axe": preload("res://weapons/axe.tscn"),
	"pickaxe": preload("res://weapons/pickaxe.tscn")
}
const WEAPON_LOOT_DICT = {
	"dagger": preload("res://objects/dagger_loot.tscn"),
	"spear": preload("res://objects/spear_loot.tscn"),
	"sword": preload("res://objects/sword_loot.tscn"),
	"axe": preload("res://objects/axe_loot.tscn"),
	"pickaxe": preload("res://objects/pickaxe_loot.tscn")
}


const INGOT = preload("res://objects/ingot.tscn")
const INVENTORY_MAX = 3

const SANITY_PER_SEC = 13

var nearby_loot = []
var nearby_loot_count = 0

var nearby_fire = null
var nearby_craft = null

var nearby_fire_light = null

var inventory = {
	"wood": 0,
	"stone": 0,
	"ore": 0,
	"ingot": 0
}

var weapon = "dagger"

var selected_loot = "wood"

var health = 100
var sanity = 100

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
			if weapon != "empty":
				$AttackCooldown.start()
				var weapon_spawn = WEAPON_DICT[weapon].instantiate()
				add_child(weapon_spawn)


	if Input.is_action_just_pressed("action_loot"):
		var did_pickup = false
		if nearby_loot.size() > 0:
			did_pickup = pickup()
		if not did_pickup and nearby_craft != null:
			pickup_craft()

	if Input.is_action_just_pressed("action_interact"):
		if (nearby_fire != null):
			add_to_fire()
		elif (nearby_craft != null):
			add_to_craft()

	if Input.is_action_just_pressed("action_item_scroll"):
		scroll()

	if Input.is_action_just_pressed("action_drop_weapon"):
		drop_weapon()

	check_in_light(delta)

	move_and_slide()

	emit_signal("current_pos", position)

func drop_weapon():
	if weapon == "empty":
		return

	var weapon_loot = WEAPON_LOOT_DICT[weapon].instantiate()
	get_parent().add_child(weapon_loot)
	weapon_loot.position = position
	weapon = "empty"
	$UnequipAudio.play()


func pickup():
	var closest_loot = null
	var closest_loot_mag = 500
	for loot in nearby_loot:
		var loot_mag = (position - loot.position).length()
		if not loot.get_placed() and loot_mag < closest_loot_mag:
			closest_loot = loot
			closest_loot_mag = loot_mag

	if closest_loot == null:
		return false

	for loot in ["wood", "stone", "ore", "ingot"]:
		if closest_loot.is_in_group(loot) and inventory[loot] < INVENTORY_MAX:
		# play sound effect
			inventory[loot] += 1
			closest_loot.queue_free()
			inventory_update()
			$PickupAudio.play()
			return true

	for loot in ["dagger", "spear", "sword", "axe", "pickaxe"]:
		if closest_loot.item_name == loot:
			if weapon != "empty":
				drop_weapon()
			weapon = loot
			closest_loot.queue_free()
			$PickupAudio.play()
			return true



	return true

func pickup_craft():
	print("pickup_craft")
	var loot_type = nearby_craft.pickup_placed(position)
	if loot_type == "empty":
		pass
	if loot_type in inventory:
		inventory[loot_type] += 1
	if loot_type in ["spear", "sword", "axe", "pickaxe"]:
		if weapon != "empty":
			var old_weapon = WEAPON_LOOT_DICT[weapon].instantiate()
			get_parent().add_child(old_weapon)
			old_weapon.position = position

		weapon = loot_type


	inventory_update()


func take_damage(hurt_damage):
	if $IFrameTimer.is_stopped():
		$IFrameTimer.start()
		$AudioStreamPlayer.play()
		health -= hurt_damage
		emit_signal("health_changed", hurt_damage)

		if (health <= 0):
			emit_signal("die")

func inventory_update():
	emit_signal("inventory_changed", inventory)

func add_to_fire():
	if selected_loot == "wood" and inventory["wood"] > 0:
		nearby_fire.add_wood()
		inventory["wood"] -= 1
	elif selected_loot == "stone" and inventory["stone"] > 0:
		$GlowLight.enabled = true
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.stop(true)
		$AnimationPlayer.play("glow_reduce")
		inventory["stone"] -= 1
		$GlowTimer.start()
	elif selected_loot == "ore" and inventory["ore"] > 0:
		inventory["ore"] -= 1
		var ingot = INGOT.instantiate()
		get_parent().add_child(ingot)
		ingot.position = position
	else:
		return
	# INGOT add to fire?
	$AddToFireAudio.play()
	inventory_update() #

func add_to_craft():
	if (inventory[selected_loot] > 0):
		nearby_craft.add_loot(position, selected_loot)
		inventory[selected_loot] -= 1
		inventory_update() #

func check_in_light(delta):
	if ($GlowTimer.is_stopped() and nearby_fire_light == null and $DarknessDamageTimer.is_stopped()):
		if (sanity > 0):
			sanity -= delta * SANITY_PER_SEC
			sanity = clamp(sanity, 0, 100)
			emit_signal("sanity_val", sanity)
		if (sanity <= 0):
			$DarknessDamageTimer.start()
			$DarknessDamageAudio.play()
			health -= 3
			emit_signal("health_changed", 3)

			if (health <= 0):
				emit_signal("die")
	elif (nearby_fire_light != null):
		sanity += delta * SANITY_PER_SEC
		sanity = clamp(sanity, 0, 100)
		emit_signal("sanity_val", sanity)



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
	if area.is_in_group("Loot"):
		nearby_loot.append(area)



func _on_pickup_area_area_exited(area):
	if area.is_in_group("Loot"):
		var i = 0
		var pop_index = -1
		for loot in nearby_loot:
			if area == loot:
				pop_index = i
				break
			i += 1

		nearby_loot.pop_at(pop_index)

func _on_pickup_area_body_entered(body):
	if body.is_in_group("fire"):
		emit_signal("interact", true)
		nearby_fire = body
	if body.is_in_group("craft"):
		emit_signal("interact", true)
		nearby_craft = body



func _on_pickup_area_body_exited(body):
	if body.is_in_group("fire"):
		emit_signal("interact", false)
		nearby_fire = null
	if body.is_in_group("craft"):
		emit_signal("interact", false)
		nearby_craft = null

func _on_glow_timer_timeout():
	$GlowLight.enabled = false


func _on_fire_light_checker_area_area_entered(area):
	if area.is_in_group("light"):
		nearby_fire_light = area

func _on_fire_light_checker_area_area_exited(area):
	if area.is_in_group("light"):
		nearby_fire_light = null


