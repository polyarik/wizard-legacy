class_name PlayerCharacter

extends CharacterBody2D


@export var speed := 64.0
var spells: Array[Spell]

@onready var casting_point := $CastingPoint
@onready var animation_tree := $PlayerAnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

# TEMP
var cast_time
var in_casting_animation := false


func learn_spells(new_spells: Array[Spell]) -> void:
	for spell in new_spells:
		if spell:
			spells.append(spell)

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
	var spell_scene: PackedScene = null
	# TODO - pick a spell
	## check cooldown and cast codition

	# TEMP - testing
	if (Input.is_action_just_pressed("ui_accept")):
		spell_scene = spells[0].scene

	if (spell_scene):
		cast_spell(spell_scene)
		in_casting_animation = true

# TODO - implement different spell types behaviour
func cast_spell(spell_scene: PackedScene) -> void:
	var spell_inst := spell_scene.instantiate()
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