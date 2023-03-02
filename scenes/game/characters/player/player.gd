class_name PlayerCharacter

extends CharacterBody2D


@export var max_health := 100.0
@export var health := 100.0
@export var speed := 64.0
var spells: Array[Spell]
var spells_timer: Array[Timer]

@onready var casting_point := $CastingPoint
@onready var animation_tree := $PlayerAnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

# TEMP
var in_casting_animation := false


func learn_spells(new_spells: Array[Spell]) -> void:
	for spell in new_spells:
		if spell:
			spells.append(spell)

			var spell_timer := Timer.new()
			add_child(spell_timer)

			spell_timer.wait_time = spell.cooldown
			spell_timer.one_shot = true
			spell_timer.timeout.connect(func(): spells[-1].on_cooldown = false) # TEST - needs testing

			spells_timer.append(spell_timer)

			# TODO - create necessary nodes for casting the spell

func _physics_process(_delta: float) -> void:
	move()
	process_spell_casting()
	pick_animation_state()

func move() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var moveX := movement.x
	var moveY := movement.y

	velocity.x = (moveX * speed) if moveX else move_toward(velocity.x, 0, speed)
	velocity.y = (moveY * speed) if moveY else move_toward(velocity.y, 0, speed)

	move_and_slide()

func process_spell_casting() -> void:
	var spell: Spell = null
	# TODO - implement spells priority
	# TODO - pick a spell that can be casted

	# TEMP - testing
	var i = 0

	if spells[i].can_be_casted():
		spell = spells[i]

	if (spell):
		cast_spell(spell)
		spells_timer[i].start()
		in_casting_animation = true

# TODO - implement different spell types behaviour
func cast_spell(spell: Spell) -> void:
	var spell_inst := spell.cast()
	spell_inst.spawned_from = self

	owner.add_child(spell_inst) # TODO - add child to $Location/Projectiles via signal
	spell_inst.position = casting_point.global_position

func pick_animation_state() -> void:
	if (velocity != Vector2.ZERO):
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
