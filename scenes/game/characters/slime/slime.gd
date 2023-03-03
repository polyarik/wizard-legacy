class_name Slime # TODO - extract base logic to "Enemy" class

extends CharacterBody2D


var max_health := 20.0
var health := max_health
var speed := 20.0

var damage := 10.0
var target: PlayerCharacter


func _physics_process(_delta):
	# TODO - sense the player only if they're near, otherwise move randomly
	if (target == null):
		target = get_tree().get_first_node_in_group("Player")

	if (target):
		velocity = position.direction_to(target.position) * speed
		move_and_slide()

func apply_damage(_damage: float) -> void:
	health = clamp(health - _damage, 0.0, max_health)

	if health == 0.0:
		queue_free()

# TEMP
func _on_hitbox_body_entered(body: Node2D):
	#if body.is_in_group("Player"):
	if body == target:
		body.apply_damage(damage)

	print(body)
