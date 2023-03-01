class_name MagicMissile

extends Area2D


var spawned_from: Node = null
var lifetime := 2.0 # seconds
var speed := 1.2
var direction := Vector2.ZERO
var damage := 5.0


func _ready():
	hanlde_lifetime()

	# TODO - detect the nearest enemy and set direction
	direction = Vector2(-1, -1).normalized() # TEMP

func hanlde_lifetime() -> void:
	var lifetime_timer := Timer.new()
	add_child(lifetime_timer)

	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(func(): queue_free())

	lifetime_timer.start()

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