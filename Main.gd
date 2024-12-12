extends Node


@onready var coins: Node = $Coins
@onready var coin_label: Label = $CanvasLayer/CoinLabel
@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var win_screen: Control = $CanvasLayer/WinScreen
@onready var win_sound: AudioStreamPlayer = $Audio/WinSound
@onready var music: AudioStreamPlayer = $Audio/Music

var total_coins: int
var collected_coins: int = 0
var time: float = 0.0


func _ready() -> void:
	for coin in coins.get_children():
		coin.picked_up.connect(on_coin_picked_up)
	total_coins = coins.get_child_count()
	update_coin_label()


func _process(delta: float) -> void:
	time += delta
	time_label.text = "Time: " + str(round(time))


func on_coin_picked_up():
	print("Only %d more coins!" % (coins.get_child_count() - 1))
	collected_coins += 1
	update_coin_label()
	
	if collected_coins == total_coins:
		win_screen.show()
		music.volume_db = -20
		win_sound.play()
		set_process(false)


func update_coin_label():
	coin_label.text = "Coins: %d/%d" % [collected_coins, total_coins]


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
