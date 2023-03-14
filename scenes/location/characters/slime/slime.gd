class_name Slime  # TODO - extract base logic to "Enemy" class
extends CharacterBody2D

signal died(entity: Slime)

var speed := 20.0
var max_health := 25.0
var health := max_health:
	get:
		return health
	set(value):
		health = value

		if health == 0.0:
			emit_signal("died", self)
			# TODO - play "death" animation and only then queue_free()
			queue_free()

var contact_damage := 10.0
var push_force := 500.0  # TEMP
var target: PlayerCharacter

var energy_reward := 10.0

@onready var animation_tree := $SlimeAnimationTree as AnimationTree
@onready var animation_state_machine := (
	animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
)


func _physics_process(_delta) -> void:
	# TODO - sense the player only if they're near, otherwise move randomly
	if target == null:
		target = get_tree().get_first_node_in_group("Player")

	if target:
		velocity = position.direction_to(target.position) * speed
		move_and_slide()


# TODO - pass the damage source refrence
func apply_damage(damage: float) -> void:
	health = clamp(health - damage, 0.0, max_health)

	if damage > 0:
		animation_state_machine.travel("hurt")
		# TODO - change current state to "hurt"
