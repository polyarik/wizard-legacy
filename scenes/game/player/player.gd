extends CharacterBody2D


@export var speed := 64.0
@onready var animation_tree := $PlayerAnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")


func _physics_process(_delta: float) -> void:
	var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var moveX := move.x
	var moveY := move.y

	velocity.x = (moveX * speed) if moveX else move_toward(velocity.x, 0, speed)
	velocity.y = (moveY * speed) if moveY else move_toward(velocity.y, 0, speed)

	move_and_slide()
	pick_animation_state()

func pick_animation_state() -> void:
	if (velocity != Vector2.ZERO):
		animation_state_machine.travel("walk")
	else:
		animation_state_machine.travel("idle")

	# TODO - handle attack animation