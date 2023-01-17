extends Node

const level_1 = preload("res://levels/level_1.tscn")

var curr_level = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	$MusicAudio.stop()
	$WinAudio.stop()
	curr_level = level_1.instantiate()
	add_child(curr_level)
	curr_level.game_over.connect(game_lost)
	$MainMenu.visible = false
	var winPanel = get_node("MainMenu/WinPanel")
	winPanel.visible = false

	$WinTimer.start()


func _on_win_timer_timeout():
	curr_level.queue_free()
	curr_level = null
	$MainMenu.visible = true
	var winPanel = get_node("MainMenu/WinPanel")
	winPanel.visible = true
	$WinAudio.play()
	# win!

	pass # Replace with function body.

func game_lost():
	curr_level.queue_free()
	curr_level = null
	$MainMenu.visible = true
	$MusicAudio.play()
	pass

func _on_button_pressed():
	start_game()


func _on_win_audio_finished():
	$MusicAudio.play()
