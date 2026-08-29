extends Area2D

@onready var pickup_sound = $PickupSound



func _on_body_entered(body):
 if body.is_in_group("player"):
  get_tree().call_group("level", "coin_collected")
  collect()
  
func collect():
 $CollisionShape2D.set_deferred("disabled", true)
 hide()
 pickup_sound.play()
 await pickup_sound.finished
 queue_free()
