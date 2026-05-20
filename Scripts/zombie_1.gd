extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ground_ray: RayCast2D = $GroundRay
@onready var hp_label: Label = $HPLabel

var speed = 150
var chase_speed = 320
var attack_range = 150.0
var attack_cooldown = 0.5
var direction = 1
var max_hp = 2
var current_hp = 2
var is_alive = true
var is_hurt = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_chasing = false
var is_attacking = false
var can_attack = true 
var player_ref: Node2D = null

func _physics_process(delta):
	if not is_alive:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_hurt or is_attacking:
		velocity.x = 0
		move_and_slide()
		return

	if is_chasing and is_instance_valid(player_ref):
		var distance_to_player = global_position.distance_to(player_ref.global_position)
		var dir_to_player = sign(player_ref.global_position.x - global_position.x)
		
		if dir_to_player != 0:
			direction = dir_to_player

		if distance_to_player <= attack_range:
			if can_attack:
				start_attack()
			else:
				velocity.x = 0
		else:
			if not ground_ray.is_colliding() and is_on_floor():
				velocity.x = 0
			elif is_on_wall():
				velocity.x = 0
			else:
				velocity.x = chase_speed * direction
	else:
		if is_on_wall():
			direction *= -1
		if not ground_ray.is_colliding() and is_on_floor():
			direction *= -1
		velocity.x = speed * direction

	move_and_slide()
	
	if not is_attacking and not is_hurt:
		if velocity.x != 0:
			animated_sprite_2d.play("walk")
			if direction > 0:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.position.x = 0
				ground_ray.position.x = abs(ground_ray.position.x)
			else:
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.position.x = -11
				ground_ray.position.x = -abs(ground_ray.position.x)
		else:
			animated_sprite_2d.stop()

func start_attack():
	is_attacking = true
	can_attack = false 
	velocity.x = 0
	
	if animated_sprite_2d.sprite_frames.has_animation("attack"):
		animated_sprite_2d.play("attack")
	
	await get_tree().create_timer(0.3).timeout 
	
	if is_attacking and is_instance_valid(player_ref):
		if global_position.distance_to(player_ref.global_position) <= attack_range + 20.0:
			if player_ref.has_method("take_damage"):
				player_ref.take_damage(1)
				
	await get_tree().create_timer(0.3).timeout 
	is_attacking = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _ready():
	update_hp_label()

func update_hp_label():
	hp_label.text = str(current_hp) + "/" + str(max_hp)

func take_damage(amount):
	if not is_alive or is_hurt:
		return
		
	is_hurt = true
	current_hp -= amount
	update_hp_label()
	
	if is_attacking:
		is_attacking = false
	
	if current_hp > 0:
		if animated_sprite_2d.sprite_frames.has_animation("hurt"):
			animated_sprite_2d.play("hurt")
		await get_tree().create_timer(0.4).timeout
		is_hurt = false
	else:
		die()

func die():
	if not is_alive:
		return
	is_alive = false
	velocity = Vector2.ZERO
	
	if animated_sprite_2d.sprite_frames.has_animation("dead"):
		animated_sprite_2d.play("dead")
		
	collision_shape_2d.set_deferred("disabled", true)
	get_tree().call_group("level", "monster_killed")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = body
		is_chasing = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_ref = null
		is_chasing = false
