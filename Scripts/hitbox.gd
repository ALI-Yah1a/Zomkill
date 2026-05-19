extends Area2D
func _on_body_entered(body):
	if body.is_in_group("enemies") and get_parent().is_attacking:
		body.take_damage(1)
