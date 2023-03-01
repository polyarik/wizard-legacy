class_name Slime

extends CharacterBody2D


var healh := 20.0
var speed := 20.0
var target: PlayerCharacter = null


func _physics_process(_delta):
	# TODO - sense the player only if they're near, otherwise move randomly
	if (target == null):
		target = get_tree().get_nodes_in_group("Player")[0]

	if (target):
		velocity = position.direction_to(target.position) * speed
		move_and_slide()
