extends Node

## 

var spell_book: SpellBook

var current_scene: Node

var location_node: Node2D
var characters_node: Node2D
var projectiles_node: Node2D
var player: PlayerCharacter

# TEMP ---
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

var energy := 0.0 # TEMP


func _ready() -> void:
	spell_book = get_node("/root/SpellBook")

	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# TEST
func goto_scene(path: String) -> void:
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path) -> void:
	current_scene.free()

	var new_scene := load(path)
	current_scene = new_scene.instantiate()

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

	# TEMP
	if path != "res://scenes/main.tscn":
		load_location()
	# TODO - location or menu

func load_location() -> void:
	location_node = get_tree().get_first_node_in_group("Location")

	characters_node = location_node.get_node_or_null("Characters")
	if characters_node == null:
		characters_node = Node2D.new()
		characters_node.name = "Characters"
		location_node.add_child(characters_node)

	projectiles_node = location_node.get_node_or_null("Projectiles")
	if projectiles_node == null:
		projectiles_node = Node2D.new()
		projectiles_node.name = "Projectiles"
		location_node.add_child(projectiles_node)

	player = location_node.get_tree().get_first_node_in_group("Player")
	energy = 0.0 # TEMP

	# TODO - only pass the picked spells to the player
	var spells: Array[Spell] = [
		spell_book.get_spell("magic_missile")
	]

	player.learn_spells(spells)

	start_spawning_enemies()

func start_spawning_enemies() -> void:
	# TODO - pass different spawn conditions
	enemy_spawn_timer = Timer.new()
	enemy_spawn_timer.name = "EnemySpawnTimer"
	add_child(enemy_spawn_timer)

	enemy_spawn_timer.wait_time = enemy_spawn_cooldown
	enemy_spawn_timer.timeout.connect(func() -> void: spawn_enemy(enemies[0])) # TEMP
	enemy_spawn_timer.start()

func spawn_enemy(enemy: PackedScene) -> void:
	var rand_radius := randf_range(enemy_min_spawn_distance, enemy_max_spawn_distance)
	var rand_angle := randf_range(0, TAU)
	var spawn_position := Vector2(cos(rand_angle)*rand_radius, sin(rand_angle)*rand_radius)

	var enemy_inst := enemy.instantiate()
	enemy_inst.global_position = player.global_position + spawn_position

	characters_node.add_child(enemy_inst)

func add_projectile(spell_inst: Node) -> void:
	projectiles_node.add_child(spell_inst)

func on_entity_death(entity: CharacterBody2D) -> void:
	if entity.is_in_group("Player"):
		on_player_death()
	elif entity.is_in_group("Enemy"):
		energy += entity.energy_reward # TEMP
		print("energy: ", energy)
		entity.queue_free()

func on_player_death() -> void:
	# TEMP
	goto_scene("res://scenes/main.tscn")

	# TODO - show death screen
