extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var punch_sfx: AudioStreamPlayer2D = $PunchSFX
@onready var hp_label: Label = $HPLabel
@onready var hitbox: Area2D = $Hitbox

const SPEED = 400.0
const RUN_SPEED = 750.0
const JUMP_VELOCITY = -880.0

var is_attacking = false
var can_attack = true
var is_hurt = false
var max_hp = 4
var current_hp = 4

func _ready():
	update_hp_label()

func update_hp_label():
	hp_label.text = str(current_hp) + "/" + str(max_hp)

func _input(event):
	if is_hurt:
		return
	
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if can_attack and not is_hurt:
		if event.is_action_pressed("attack_1"):
			attack("attack_1")
		elif event.is_action_pressed("attack_2"):
			attack("attack_2")
		elif event.is_action_pressed("attack_3"):
			attack("attack_3")

func _physics_process(delta):
	if is_hurt or is_attacking:
		velocity.x = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction = Input.get_axis("walk_left", "walk_right")
	var is_running = Input.is_action_pressed("run")

	if direction != 0:
		if is_running:
			velocity.x = direction * RUN_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_facing_direction(direction)
	update_animations(direction, is_running)

func update_facing_direction(direction: float):
	if direction == 0:
		return 
		
	var is_facing_left = direction < 0
	animated_sprite_2d.flip_h = is_facing_left
	
	if is_facing_left:
		animated_sprite_2d.position.x = -12.5
		$Hitbox.position.x = -abs($Hitbox.position.x)
	else:
		animated_sprite_2d.position.x = 0
		$Hitbox.position.x = abs($Hitbox.position.x)

func update_animations(direction: float, is_running: bool):
	if not is_on_floor():
		if animated_sprite_2d.animation != "jump":
			animated_sprite_2d.play("jump")
	elif direction != 0:
		if is_running:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")

func attack(attack_anim: String):
	is_attacking = true
	can_attack = false
	animated_sprite_2d.play(attack_anim)
	$Hitbox.monitoring = true
	punch_sfx.play()

func take_damage(amount):
	if is_hurt:
		return
	current_hp -= amount
	update_hp_label()
	
	if is_attacking:
		is_attacking = false
		can_attack = true
		$Hitbox.set_deferred("monitoring", false)
	
	if current_hp > 0:
		is_hurt = true
		animated_sprite_2d.play("hurt")
		await animated_sprite_2d.animation_finished
		is_hurt = false
	else:
		die()

func die():
	set_physics_process(false)
	animated_sprite_2d.play("dead")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation in ["attack_1", "attack_2", "attack_3"]:
		is_attacking = false
		can_attack = true
		$Hitbox.monitoring = false
