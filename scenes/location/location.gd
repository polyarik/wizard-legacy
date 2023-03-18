class_name Location
extends Node2D

var location_name := "Template"

var location_node: Node2D
var characters_node: Node2D
var projectiles_node: Node2D

var player: PlayerCharacter

# TEMP --- TODO - implement Spawner class
#var enemies: Array[Enemy] # TODO
var enemies: Array[PackedScene] = [
	preload("res://scenes/location/characters/slime/slime.tscn"),  # TODO? - get reference from Preloads.enemies.slime
]
# TODO - implement different spawn modes
# TODO - implement world boundaries
var enemy_min_spawn_distance := 256
var enemy_max_spawn_distance := 512
var enemy_despawn_distance := 1024
var enemy_spawn_timer: Timer
var enemy_spawn_cooldown := 2.0

var energy := 0.0  # TEMP


func _ready() -> void:
	get_location_nodes()
	# TODO - play location animation
	print("LOCATION: ", location_name)  # TEST

	energy = 0.0  # TEMP

	start_spawning_enemies()


func get_location_nodes() -> void:
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
	player.died.connect(on_player_death)
	player.cast.connect(add_projectile)  # TODO - connect to player's SpellManager


func start_spawning_enemies() -> void:
	# TODO - implement different spawn conditions
	enemy_spawn_timer = Globals.create_timer(
		func() -> void: spawn_enemy(enemies[0]), enemy_spawn_cooldown, false, "EnemySpawnTimer"  # TEMP
	)

	add_child(enemy_spawn_timer)
	enemy_spawn_timer.start()


func spawn_enemy(enemy: PackedScene) -> void:
	var rand_radius := randf_range(enemy_min_spawn_distance, enemy_max_spawn_distance)
	var rand_angle := randf_range(0, TAU)
	var spawn_position := Vector2(cos(rand_angle) * rand_radius, sin(rand_angle) * rand_radius)

	var enemy_inst := enemy.instantiate()
	enemy_inst.died.connect(on_entity_death)
	enemy_inst.global_position = player.global_position + spawn_position

	characters_node.add_child(enemy_inst)


func add_projectile(spell_inst: Node) -> void:
	projectiles_node.add_child(spell_inst)


func on_entity_death(entity: CharacterBody2D) -> void:
	if entity.is_in_group("Enemy"):
		energy += entity.energy_reward  # TEMP; TODO - handle leveling system
		print("energy: ", energy)


func on_player_death() -> void:
	PhysicsServer2D.set_active(false)

	# TODO - show death screen -> goto_home
	enemy_spawn_timer.stop()

	SceneManager.goto_home()  # TEMP
