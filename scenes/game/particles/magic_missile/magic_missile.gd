class_name MagicMissile

extends Area2D


var spawned_from: Node = null
var lifetime := 2.0 # seconds
var speed := 64 # px/sec
var direction := Vector2.ZERO
var damage := 5.0


func _ready() -> void:
	hanlde_lifetime()

func hanlde_lifetime() -> void:
	var lifetime_timer := Timer.new()
	add_child(lifetime_timer)

	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(func() -> void: queue_free())

	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body == spawned_from:
		return

	if body.is_in_group("Enemy"):
		var enemy := body as Slime # TODO - as Enemy
		enemy.apply_damage(damage)
		queue_free()
	elif body.is_in_group("Static"):
		queue_free()

func _exit_tree() -> void:
	# TODO - play "destroy" animation
	pass
