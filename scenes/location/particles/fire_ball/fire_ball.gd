class_name FireBall
extends Area2D

var spawned_from: Node = null
var speed := 50  # px/sec
var direction := Vector2.ZERO
var damage := 15.0
var blast_damage := 5

@onready var blast_area := $BlastHitbox as Area2D


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body == spawned_from:
		return

	if body.is_in_group("Enemy"):
		var enemy := body as Slime  # TODO - as Enemy
		enemy.apply_damage(damage, spawned_from)
		blast()
		queue_free()
	elif body.is_in_group("Static"):
		blast()
		queue_free()

	# TODO - play "destroy" animation


func blast() -> void:
	for body in blast_area.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			var enemy := body as Slime  # TODO - as Enemy
			enemy.apply_damage(blast_damage, spawned_from)

	# TODO - play "blast" animation


func _on_lifetime_timer_timeout() -> void:
	# TODO - play "fade" animation
	queue_free()
