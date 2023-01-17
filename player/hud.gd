extends CanvasLayer

var health = 100
var sanity = 100
var inventory = {
	"wood": 0,
	"stone": 0,
	"ore": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	Globals.player.health_changed.connect(_on_health_change)
#	Globals.player.inventory_changed.connect(_on_inventory_change)
#	Globals.player.selected_loot_changed.connect(_on_select_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimeLeftLabel.text = "%d:%02d" % [floor($TimeLeftTimer.time_left / 60), int($TimeLeftTimer.time_left) % 60]


func _on_inventory_changed(change):
	inventory = change
	$InventoryLabel.text = "wood: %d\nstone: %d\nore:     %d\ningot:  %d" % [inventory["wood"], inventory["stone"], inventory["ore"], inventory["ingot"]]


func _on_health_changed(change):
	health -= change
	$Healthbar.size.x = health * 8


func _on_selected_loot_changed(loot_sel):
	$LootSelectLabel.text = "Selected: " + loot_sel


func _on_player_sanity_val(new_sanity):
	sanity = new_sanity
	$SanityBar.size.x = sanity * 4
