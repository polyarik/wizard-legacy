class_name MagicMissile

extends Area2D


var spawned_from: Node = null
var speed := 1.2
var direction := Vector2.ZERO
var damage := 5.0


func _ready():
	# TODO - detect the nearest enemy and set direction
	direction = Vector2(-1, -1).normalized() # TEMP

func _physics_process(_delta: float) -> void:
	position += direction * speed

func _on_body_entered(body: Node2D) -> void:
	if body == spawned_from:
		return

	if body.is_in_group("Enemy"):
		var enemy := body as Slime # TODO - as Enemy
		enemy.apply_damage(damage)
		queue_free()
	elif body.is_in_group("Static"):
		queue_free()

func _exit_tree():
	# TODO - play "destroy" animation
	pass