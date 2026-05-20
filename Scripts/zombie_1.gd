extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var killzone: Area2D = $Killzone
@onready var ground_ray: RayCast2D = $GroundRay
@onready var hp_label: Label = $HPLabel

var speed = 320
var direction = 1
var max_hp = 2
var current_hp = 2
var is_alive = true
var is_hurt = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_alive or is_hurt:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall():
		direction *= -1
	if not ground_ray.is_colliding() and is_on_floor():
		direction *= -1
		
	velocity.x = speed * direction
	move_and_slide()
	
	if direction != 0:
		animated_sprite_2d.play("walk")
		if direction > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.position.x = 0
			ground_ray.position.x = abs(ground_ray.position.x)
		else:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.position.x = -11
			ground_ray.position.x = -abs(ground_ray.position.x)

func _ready():
	update_hp_label()

func update_hp_label():
	hp_label.text = str(current_hp) + "/" + str(max_hp)

func take_damage(amount):
	if not is_alive or is_hurt:
		return
	current_hp -= amount
	update_hp_label()
	if current_hp > 0:
		is_hurt = true
		animated_sprite_2d.play("hurt")
		await get_tree().create_timer(0.3).timeout
		is_hurt = false
	if current_hp <= 0:
		die()

func die():
	if not is_alive:
		return
	is_alive = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("dead")
	collision_shape_2d.set_deferred("disabled", true)
	killzone.set_deferred("monitoring", false)
	get_tree().call_group("level", "monster_killed")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_killzone_body_entered(body: Node2D) -> void:
	if not is_alive or is_hurt:
		return
	if body.is_in_group("player"):
		if body.is_attacking:
			take_damage(1)
			await get_tree().create_timer(0.5)
		else:
			body.take_damage(1)
