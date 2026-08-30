extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var bounce_force := -2000

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		animated_sprite_2d.play("jump")
		body.velocity.y = bounce_force
