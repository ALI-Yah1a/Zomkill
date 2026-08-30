extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var zombies_label: Label = $UI/VBoxContainer/ZombiesLabel
@onready var coins_label: Label = $UI/VBoxContainer/Coins_label
@onready var level_complete_ui: CanvasLayer = $LevelCompleteUI
@onready var main_menu_button: Button = $LevelCompleteUI/HBoxContainer/MainMenuButton


var zombies_killed = 0
var coins_collected = 0
const REQUIRES_COINS = 20
const REQUIRED_ZOMBIES = 20

func _ready():
	level_complete_ui.visible = false
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	update_ui()

func update_ui():
	zombies_label.text = "Zombies: " + str(zombies_killed) + " / " + str(REQUIRED_ZOMBIES)
	coins_label.text = "Coins: " + str(coins_collected) + " / " + str(REQUIRES_COINS)
func zombie_killed():
	zombies_killed += 1
	update_ui()
	level_finished()
func coin_collected():
	coins_collected += 1
	update_ui()
	level_finished()
func level_finished():
	if zombies_killed >= REQUIRED_ZOMBIES and coins_collected >= REQUIRES_COINS:
		
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = true
		level_complete_ui.visible = true

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
