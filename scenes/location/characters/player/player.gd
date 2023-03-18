class_name PlayerCharacter
extends CharacterBody2D

signal began_spell_cast(spell_num: int)  # TODO - receive in SpellManager
signal cast(spell_inst: Node)  # TODO - rename to "cast_spell", emit in SpellManager?
signal health_changed(change: float, value: float, max: float)
signal died()

@export var speed := 64.0
@export var max_health := 100.0
@export var health := 100.0:
	get:
		return health
	set(value):
		emit_signal("health_changed", value - health, value, max_health)
		health = value

		if health == 0.0:
			emit_signal("died")
			# TODO - play "death" animation

var spells: Array[Spell]
var spells_timer: Array[Timer]
var spells_cast_timer: Array[Timer]  # TEMP
var spells_target: Array[Node2D]  # TEMP

# TODO - implement something like "states"
var is_casting := false
var is_hurt := false

@onready var animation_tree := $PlayerAnimationTree as AnimationTree
@onready var animation_state_machine := (
	animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
)

@onready var spell_manager := $SpellManager as Node2D  # TODO - move all casting logic to SpellManager class
@onready var enemy_detection_timer := $SpellManager/EnemyDetectionTimer as Timer
@onready var casting_point := $CastingPoint as Marker2D


func _ready() -> void:
	for spell_name in Globals.picked_spells:
		var spell = SpellBook.get_spell(spell_name)
		learn_spell(spell)

	began_spell_cast.connect(_on_cast_spell)  # TEMP - move to SpellManager
	print("player health: ", health)


# TODO - refactor
func learn_spell(spell: Spell) -> void:
	if not spell:
		return
	
	spells.append(spell)
	var spell_num := len(spells) - 1

	var spell_nodes := Node2D.new()
	spell_nodes.name = "SpellNodes" + str(spell_num)
	spell_manager.add_child(spell_nodes)

	var spell_timer := Globals.create_timer(
		func() -> void: spells[spell_num].on_cooldown = false,
		spell.cooldown,
		true,
		"SpellCooldown" + str(spell_num)
	)

	spell_nodes.add_child(spell_timer)
	spells_timer.append(spell_timer)

	# TODO? - use match
	if spell.cast_conditions.has("max_distance"):
		spells_target.append(null)

		var area_radius: float = spell.cast_conditions["max_distance"]
		var enemy_detection_area := Globals.create_circle_area(
			area_radius, 0, 4, "EnemyDetection" + str(spell_num)
		)
		spell_nodes.add_child(enemy_detection_area)

		#if spell.target == "closest":
		enemy_detection_timer.timeout.connect(
			func() -> void:
				var closest_enemy: CharacterBody2D = null
				var min_dist: float = spell.cast_conditions["max_distance"]

				for body in enemy_detection_area.get_overlapping_bodies():
					if body.is_in_group("Enemy"):
						var new_dist := global_position.distance_to(body.global_position)

						if new_dist <= min_dist:
							min_dist = new_dist
							closest_enemy = body

				spells_target[spell_num] = closest_enemy
				spells[spell_num].conditions_met["max_distance"] = true if closest_enemy else false
		)

		if spell.cast_conditions.has("visible_target"):
			# TODO
			print("-_-")

	var spell_cast_timer := Globals.create_timer(
		func() -> void:
			spells_timer[spell_num].start()  # start spell cooldown
			self.is_casting = false

			if spells_target[spell_num] and is_instance_valid(spells_target[spell_num]):  # TEMP
				cast_spell(spells[spell_num], spells_target[spell_num].global_position),
		spell.cast_time,
		true,
		"SpellCastingDelay" + str(spell_num)
	)

	spell_nodes.add_child(spell_cast_timer)
	spells_cast_timer.append(spell_cast_timer)


func _physics_process(_delta: float) -> void:
	move()
	process_spell_casting()


func move() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var moveX := movement.x
	var moveY := movement.y

	if is_hurt:  # TEMP - unwanted behavior: animation dependable
		velocity.x = move_toward(velocity.x, moveX * speed, speed)
		velocity.y = move_toward(velocity.y, moveY * speed, speed)
	else:
		velocity.x = (moveX * speed) if moveX else move_toward(velocity.x, 0, speed)
		velocity.y = (moveY * speed) if moveY else move_toward(velocity.y, 0, speed)

		if velocity != Vector2.ZERO:
			animation_state_machine.travel("walk")

	move_and_slide()


func process_spell_casting() -> void:
	if is_casting:
		return

	var i := 0

	for spell in spells:
		if not spell.can_be_casted():
			i += 1
		else:
			animation_state_machine.travel("attack")
			is_casting = true

			emit_signal("began_spell_cast", i)
			return


# TODO - move to SpellManager
func _on_cast_spell(spell_num: int) -> void:
	spells_cast_timer[spell_num].start()  # cast spell after spell.cast_time


# TODO - move to SpellManager class; implement different spell types behaviour
func cast_spell(spell: Spell, target_position: Vector2) -> void:
	var spell_inst := spell.cast()
	spell_inst.spawned_from = self

	var spell_position: Vector2 = (
		casting_point.global_position if casting_point else global_position
	)
	spell_inst.position = spell_position
	spell_inst.direction = spell_position.direction_to(target_position)  # TEMP

	emit_signal("cast", spell_inst)


# TODO - refresh hirtbox
func _on_hirtbox_area_entered(area: Area2D):  # TODO - (area: Hitbox)  <- script for Hitbox
	# TEMP
	var body := area.get_parent()

	if body.is_in_group("Enemy"):
		#if body.target == self:
		apply_damage(body.contact_damage)

		var push_force: Vector2 = body.position.direction_to(global_position) * body.push_force
		push(push_force)


# TODO - pass the damage source refrence (for some statistics?)
func apply_damage(damage: float) -> void:
	health = clamp(health - damage, 0.0, max_health)

	if damage > 0:
		animation_state_machine.travel("hurt")
		is_hurt = true

	print("player health: ", health)


func push(force: Vector2) -> void:
	velocity += force


func _on_player_animation_tree_animation_finished(anim_name: StringName):
	match anim_name:
		"hurt":
			is_hurt = false
