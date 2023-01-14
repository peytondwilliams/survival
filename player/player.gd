extends CharacterBody2D

const SPEED = 100.0
const SPEAR = preload("res://weapons/spear.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
		var spear = SPEAR.instantiate()
		add_child(spear)


	move_and_slide()
