extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var zombies_label: Label = $CanvasLayer/ZombiesLabel
@onready var level_complete_ui: CanvasLayer = $LevelCompleteUI
@onready var next_level_button: Button = $LevelCompleteUI/HBoxContainer/NextLevelButton
@onready var main_menu_button: Button = $LevelCompleteUI/HBoxContainer/MainMenuButton
var zombies_killed = 0
const REQUIRED_ZOMBIES = 1

func _ready():
	level_complete_ui.visible = false
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	update_ui()

func update_ui():
	zombies_label.text = "Monsters: " + str(zombies_killed) + " / " + str(REQUIRED_ZOMBIES)

func zombie_killed():
	zombies_killed += 1
	update_ui()
	level_finished()
func level_finished():
	if zombies_killed >= REQUIRED_ZOMBIES:
		get_tree().paused = true
		level_complete_ui.visible = true

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
