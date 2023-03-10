extends Node

## 


var location_node: Node2D
var characters_node: Node2D
var projectiles_node: Node2D
var player: PlayerCharacter

# TEMP ---
#var enemies: Array[Enemy] # TODO
var enemies: Array[PackedScene] = [
	preload("res://scenes/game/characters/slime/slime.tscn"),
]
# TODO - implement different spawn modes
# TODO - implement world boundaries
var enemy_min_spawn_distance := 256
var enemy_max_spawn_distance := 512
var enemy_despawn_distance := 1024
var enemy_spawn_timer: Timer
var enemy_spawn_cooldown := 2.0

var energy := 0.0 # TEMP


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

	var spells: Array[Spell] = []

	for spell in Globals.picked_spells:
		spells.append(SpellBook.get_spell(spell))

	player.learn_spells(spells)

	start_spawning_enemies()
	PhysicsServer2D.set_active(true)

func start_spawning_enemies() -> void:
	# TODO - implement different spawn conditions
	enemy_spawn_timer = Globals.create_timer(
		func() -> void: spawn_enemy(enemies[0]), # TEMP
		enemy_spawn_cooldown,
		false,
		"EnemySpawnTimer"
	)

	add_child(enemy_spawn_timer)
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
	PhysicsServer2D.set_active(false)

	# TODO - show death screen -> goto_home

	# TEMP
	enemy_spawn_timer.stop()
	enemy_spawn_timer.queue_free()

	SceneManager.goto_home()
