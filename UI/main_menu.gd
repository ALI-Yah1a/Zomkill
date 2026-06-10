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


func _on_options_2_pressed() -> void:
	buttons.visible = false
	level_selection.visible = false


func _on_exit_3_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_ready()

func _on_level_button_3_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
