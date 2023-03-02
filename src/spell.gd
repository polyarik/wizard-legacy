class_name Spell

extends Area2D


var scene: PackedScene
var cast_conditions: Array[String]
var cooldown: float
var on_cooldown := false

# TODO - add levels and their specific upgrades


func _init(_scene: PackedScene, _cast_conditions: Array[String], _cooldown:=1.0):
	scene = _scene
	cooldown = _cooldown
	cast_conditions = _cast_conditions

func can_be_casted() -> bool:
	# TODO - check all conditions
	return not on_cooldown

func cast() -> Node:
	on_cooldown = true
	return scene.instantiate()
