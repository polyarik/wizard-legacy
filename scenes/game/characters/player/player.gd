class_name PlayerCharacter

extends CharacterBody2D


@export var max_health := 100.0
@export var health := 100.0
@export var speed := 64.0

var spells: Array[Spell]
var spells_timer: Array[Timer]
var spells_target: Array[Node2D] # TEMP

# TODO - implement something like "states"
var in_casting_animation := false
var is_hurt := false

@onready var casting_point := $CastingPoint as Marker2D
@onready var animation_tree := $PlayerAnimationTree as AnimationTree
@onready var animation_state_machine := animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback


func _ready() -> void:
	print("player health: ", health)

# TODO - refactor
func learn_spells(new_spells: Array[Spell]) -> void:
	for spell in new_spells:
		if spell:
			spells.append(spell)

			var spell_timer := Timer.new()
			add_child(spell_timer)

			spell_timer.wait_time = spell.cooldown
			spell_timer.one_shot = true
			spell_timer.timeout.connect(func() -> void: spells[-1].on_cooldown = false) # TEST - needs testing

			spells_timer.append(spell_timer)

			if spell.cast_conditions.has("max_distance"):
				spells_target.append(null)

				var area := Area2D.new()
				area.collision_layer = 0
				area.collision_mask = 4
				add_child(area)

				var circle_shape := CircleShape2D.new()
				circle_shape.radius = spell.cast_conditions["max_distance"]

				var collision_shape := CollisionShape2D.new()
				collision_shape.shape = circle_shape
				area.add_child(collision_shape)

				# BUG - doesn't handle enemy movement inside the area!
				area.body_entered.connect(func(body: Node2D) -> void:
					if body.is_in_group("Enemy"):
						if spells_target[-1]:
							var curr_dist := global_position.distance_to(spells_target[-1].global_position)
							var new_dist := global_position.distance_to(body.global_position)

							if new_dist < curr_dist:
								spells_target[-1] = body
						else:
							spells_target[-1] = body

						spells[-1].conditions_met["max_distance"] = true
				)

				# TODO - rewrite!
				area.body_exited.connect(func(body: Node2D) -> void:
					if body == spells_target[-1]:
						spells_target[-1] = null
						spells[-1].conditions_met["max_distance"] = false

						var remaining_bodies := area.get_overlapping_bodies()

						for remaining_body in remaining_bodies:
							if remaining_body != body and remaining_body.is_in_group("Enemy"):
								spells_target[-1] = remaining_body
								spells[-1].conditions_met["max_distance"] = true
				)

				if spell.cast_conditions.has("visible_target"):
					# TODO
					print("-_-")

func _physics_process(_delta: float) -> void:
	move()
	process_spell_casting()
	pick_animation_state()

func move() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var moveX := movement.x
	var moveY := movement.y

	if is_hurt: # TEMP - unwanted behavior: animation dependable
		velocity.x = move_toward(velocity.x, moveX * speed, speed)
		velocity.y = move_toward(velocity.y, moveY * speed, speed)
	else:
		velocity.x = (moveX * speed) if moveX else move_toward(velocity.x, 0, speed)
		velocity.y = (moveY * speed) if moveY else move_toward(velocity.y, 0, speed)

	move_and_slide()

func process_spell_casting() -> void:
	var spell: Spell = null
	var target_pos: Vector2 # TEMP
	# TODO - implement spells priority
	# TODO - pick a spell that can be casted

	# TEMP - testing
	var i := 0

	if spells[i].can_be_casted():
		spell = spells[i]
		target_pos = spells_target[i].global_position

	if (spell):
		cast_spell(spell, target_pos) # TEMP
		spells_timer[i].start()
		in_casting_animation = true

# TODO - implement different spell types behaviour
func cast_spell(spell: Spell, target_pos: Vector2) -> void:
	var spell_inst := spell.cast()
	spell_inst.spawned_from = self
	spell_inst.position = casting_point.global_position
	spell_inst.direction = casting_point.global_position.direction_to(target_pos) # TEMP

	GameManager.add_projectile(spell_inst)

func apply_damage(_damage: float) -> void:
	health = clamp(health - _damage, 0.0, max_health)
	# TEMP
	is_hurt = true
	in_casting_animation = false

	print("player health: ", health)

	# TODO - visual effect

	if health == 0.0:
		GameManager.on_entity_death(self)

func push(force: Vector2) -> void:
	velocity += force

# TODO - rewrite
func pick_animation_state() -> void:
	if is_hurt:
		animation_state_machine.travel("hurt")
	elif (velocity != Vector2.ZERO):
		animation_state_machine.travel("walk")
		in_casting_animation = false
	elif (in_casting_animation):
		animation_state_machine.travel("attack")
	else:
		animation_state_machine.travel("idle")

func _on_player_animation_tree_animation_finished(anim_name: StringName):
	match anim_name:
		"attack":
			in_casting_animation = false
		"hurt":
			is_hurt = false
