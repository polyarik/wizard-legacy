class_name MagicMissile
extends Area2D

var spawned_from: Node = null
var speed := 64  # px/sec
var direction := Vector2.ZERO
var damage := 5.0


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


# TODO - detect collision with Hurtbox and disable "monitorable"
func _on_body_entered(body: Node2D) -> void:
	if body == spawned_from:
		return

	if body.is_in_group("Enemy"):
		var enemy := body as Slime  # TODO - as Enemy
		enemy.apply_damage(damage, spawned_from)
		queue_free()
	elif body.is_in_group("Static"):
		queue_free()

	# TODO - play "destroy" animation


func _on_area_entered(_area: Area2D) -> void:
	#print("area ", area)
	pass


# TODO? - separate Static cillision detection


func _on_lifetime_timer_timeout() -> void:
	# TODO - play "fade" animation
	queue_free()
