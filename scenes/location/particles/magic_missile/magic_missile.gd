class_name MagicMissile
extends Area2D

var spawned_from: Node = null
var speed := 64  # px/sec
var direction := Vector2.ZERO
var damage := 5.0


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body == spawned_from:
		return

	if body.is_in_group("Enemy"):
		var enemy := body as Slime  # TODO - as Enemy
		enemy.apply_damage(damage)
		queue_free()
	elif body.is_in_group("Static"):
		queue_free()

	# TODO - play "destroy" animation


func _on_lifetime_timer_timeout():
	# TODO - play "fade" animation
	queue_free()
