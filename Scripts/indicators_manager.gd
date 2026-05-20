extends CanvasLayer

@export var indicator_scene: PackedScene
@export var margin: float = 40.0

var indicators = {}

func _process(_delta):
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return

	var screen_size = get_viewport().get_visible_rect().size
	var screen_center = screen_size / 2.0
	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if not indicators.has(enemy):
			var new_indicator = indicator_scene.instantiate()
			add_child(new_indicator)
			indicators[enemy] = new_indicator

	var dead_enemies = []
	
	for enemy in indicators.keys():
		if not is_instance_valid(enemy):
			indicators[enemy].queue_free()
			dead_enemies.append(enemy)
			continue

		var indicator = indicators[enemy]
		var diff = enemy.global_position - camera.global_position
		var half_screen = screen_center

		if abs(diff.x) < half_screen.x and abs(diff.y) < half_screen.y:
			indicator.hide()
		else:
			indicator.show()
			var dir = diff.normalized()
			
			var scale_x = INF
			if abs(diff.x) > 0.001:
				scale_x = (half_screen.x - margin) / abs(diff.x)
				
			var scale_y = INF
			if abs(diff.y) > 0.001:
				scale_y = (half_screen.y - margin) / abs(diff.y)
				
			var min_scale = min(scale_x, scale_y)
			
			indicator.position = screen_center + (diff * min_scale)
			indicator.rotation = dir.angle()

	for dead in dead_enemies:
		indicators.erase(dead)
