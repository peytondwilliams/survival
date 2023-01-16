extends StaticBody2D

const LOOT_DICT = {
	"wood": preload("res://objects/wood.tscn"),
	"stone": preload("res://objects/stone.tscn"),
	"ore": preload("res://objects/ore.tscn"),
	"ingot": preload("res://objects/ingot.tscn"),
	"spear": preload("res://objects/spear_loot.tscn"),
	"sword": preload("res://objects/sword_loot.tscn"),
	"axe": preload("res://objects/axe_loot.tscn"),
	"pickaxe": preload("res://objects/pickaxe_loot.tscn")
}


var loot_arr = [null, null, null]
var point_arr = []
# Called when the node enters the scene tree for the first time.
func _ready():
	point_arr = [$Point1, $Point2, $Point3]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func closest_slot(player_pos):
	var closest_index = -1
	var closest_dist = 300

	for i in 3:
		var dist = (position + point_arr[i].position - player_pos).length()
		if dist < closest_dist:
			closest_dist = dist
			closest_index = i

	return closest_index

func add_loot(player_pos, loot_type):
	$PlaceAudio.play()
	var closet_index = closest_slot(player_pos)

	var loot = LOOT_DICT[loot_type].instantiate()
	loot.set_placed(true)
	add_child(loot)
	loot.position = point_arr[closet_index].position

	if loot_arr[closet_index] != null:
		var old_loot = loot_arr[closet_index]

		remove_child(old_loot)
		get_parent().add_child(old_loot)
		old_loot.set_placed(false)
		old_loot.position = position + point_arr[closet_index].position + Vector2(0, 16)
		#need to get rid the object
	loot_arr[closet_index] = loot

	#check recipe
	if (loot_arr[0] != null and loot_arr[1] != null and loot_arr[2] != null):
		craft_item()


func craft_item():

	var totals = {
		"wood": 0,
		"stone": 0,
		"ore": 0,
		"ingot": 0
	}

	for i in 3:
		totals[loot_arr[i].item_name] += 1

	if(totals["wood"] == 3):
		clear_loot_arr()
		var spear = LOOT_DICT["spear"].instantiate()
		loot_arr[1] = spear
		add_child(spear)
		spear.position = point_arr[1].position

	elif(totals["wood"] == 2 and totals["stone"] == 1):
		clear_loot_arr() #axe
		var axe = LOOT_DICT["axe"].instantiate()
		loot_arr[1] = axe
		add_child(axe)
		axe.position = point_arr[1].position

	elif(totals["wood"] == 1 and totals["stone"] == 2):
		clear_loot_arr() #pickaxe
		var pickaxe = LOOT_DICT["pickaxe"].instantiate()
		loot_arr[1] = pickaxe
		add_child(pickaxe)
		pickaxe.position = point_arr[1].position

	elif(totals["wood"] == 1 and totals["ingot"] == 2):
		clear_loot_arr() #sword
		var sword = LOOT_DICT["sword"].instantiate()
		loot_arr[1] = sword
		add_child(sword)
		sword.position = point_arr[1].position
	else:
		# bad recipe
		$BadCraftAudio.play()
		return
	$CraftAudio.play()


func clear_loot_arr():
	for i in 3:
		loot_arr[i].queue_free()
		loot_arr[i] = null

func pickup_placed(player_pos):
	var loot_type = "empty"

	var closest_index = closest_slot(player_pos)

	if loot_arr[closest_index] == null:
		return loot_type

	if loot_arr[closest_index].is_in_group("Loot"):
		loot_type = loot_arr[closest_index].item_name

	loot_arr[closest_index].queue_free()
	loot_arr[closest_index] = null

	return loot_type


	#Armor
	#Sword
	#Bow?
	#




