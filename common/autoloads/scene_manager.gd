extends CanvasLayer

var home_scene := preload("res://scenes/home/home.tscn")

var locations := {
	test = preload("res://scenes/location/locations/test_location.tscn"),
}
# TODO - story & survival locations

var current_scene: Node

@onready var animation_player := $TransitionAnimations as AnimationPlayer


func _ready() -> void:
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_location(location_name: String) -> void:
	var location: PackedScene = locations.get(location_name, null)

	if location:
		animation_player.play("to_location")
		await animation_player.animation_finished

		PhysicsServer2D.set_active(true)
		call_deferred("_deferred_goto_scene", location)

		animation_player.call_deferred("play_backwards", "to_location")


func goto_home() -> void:
	PhysicsServer2D.set_active(false)

	# TODO - handle location progress results

	animation_player.play("to_home")
	await animation_player.animation_finished

	call_deferred("_deferred_goto_scene", home_scene)

	animation_player.call_deferred("play_backwards", "to_home")


func _deferred_goto_scene(scene: PackedScene) -> void:
	current_scene.free()
	current_scene = scene.instantiate()
	# TODO - connect signals

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
