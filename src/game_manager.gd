extends Node

## 

var spell_book: SpellBook
var location: Node2D
var characters_node: Node2D
var player: PlayerCharacter

#var enemies: Array[Enemy] # TODO
var enemies := [
	preload("res://scenes/game/characters/slime/slime.tscn"),
]
# TODO - implement different spawn modes
# TODO - implement world boundaries
var enemy_min_spawn_distance := 256
var enemy_max_spawn_distance := 512
var enemy_despawn_distance := 1024
var enemy_spawn_timer: Timer
var enemy_spawn_cooldown := 4.0


func _ready() -> void:
	spell_book = get_node("/root/SpellBook")

	location = get_tree().get_first_node_in_group("Location")
	characters_node = location.get_node("Characters")
	player = location.get_tree().get_first_node_in_group("Player")

	# TODO - only pass the picked spells to the player
	var spells: Array[Spell] = [
		spell_book.get_spell("magic_missile")
	]

	player.learn_spells(spells)

	start_spawning_enemies()

func start_spawning_enemies() -> void:
	# TODO - pass different spawn conditions
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)

	enemy_spawn_timer.wait_time = enemy_spawn_cooldown
	enemy_spawn_timer.timeout.connect(func(): spawn_enemy(enemies[0])) # TEMP
	enemy_spawn_timer.start()

func spawn_enemy(enemy: PackedScene) -> void:
	var rand_radius = randf_range(enemy_min_spawn_distance, enemy_max_spawn_distance)
	var rand_angle = randf_range(0, TAU)
	var spawn_position := Vector2(cos(rand_angle)*rand_radius, sin(rand_angle)*rand_radius)

	var enemy_inst = enemy.instantiate()
	enemy_inst.global_position = player.global_position + spawn_position

	characters_node.add_child(enemy_inst)