extends Node


func _ready():
	print("loading")

	# TODO - preload everything

	GameManager.goto_scene("res://scenes/game/locations/demo_location.tscn") # TEST