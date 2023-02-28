extends CharacterBody2D


@export var speed := 64.0


func _physics_process(_delta: float) -> void:
	var moveX := Input.get_axis("ui_left", "ui_right")
	var moveY := Input.get_axis("ui_up", "ui_down")

	velocity.x = (moveX * speed) if moveX else move_toward(velocity.x, 0, speed)
	velocity.y = (moveY * speed) if moveY else move_toward(velocity.y, 0, speed)

	move_and_slide()
