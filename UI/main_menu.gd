extends Control
@onready var buttons: VBoxContainer = $Buttons

@onready var level_selection: Panel = $LevelSelection


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons.visible = true
	level_selection.visible = false


func _on_start_pressed() -> void:
	buttons.visible = false
	level_selection.visible = true


func _on_exit_3_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_ready()


func _on_button_1_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_2_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")


func _on_button_3_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")


func _on_button_4_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_4.tscn")


func _on_button_5_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_5.tscn")
