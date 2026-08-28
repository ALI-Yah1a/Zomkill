extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var zombies_label: Label = $CanvasLayer/ZombiesLabel

var zombies_killed = 0
const REQUIRED_ZOMBIES = 13

func _ready():

	update_ui()

func update_ui():
	zombies_label.text = "Monsters: " + str(zombies_killed) + " / " + str(REQUIRED_ZOMBIES)

func zombie_killed():
	zombies_killed += 1
	update_ui()
	level_finished()
func level_finished():
	if zombies_killed >= REQUIRED_ZOMBIES:
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
