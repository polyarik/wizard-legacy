extends Node


var home_scene := preload("res://scenes/home/home.tscn")
#var transition # TODO

var locations := {
	demo = preload("res://scenes/game/locations/demo_location.tscn"),
}

var current_scene: Node


func _ready():
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_location(location_name: String) -> void:
	var location: PackedScene = locations.get(location_name, null)

	if location:
		call_deferred("_deferred_goto_scene", location)
		GameManager.call_deferred("load_location")

func goto_home() -> void:
	# TODO - handle location progress results

	call_deferred("_deferred_goto_scene", home_scene)

func _deferred_goto_scene(scene: PackedScene) -> void:
	current_scene.free()
	current_scene = scene.instantiate()

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
