class_name Spell


var scene: PackedScene
var cast_conditions: Array[String]
var cooldown: float

# TODO - add levels and their specific upgrades


func _init(_scene: PackedScene, _cast_conditions: Array[String], _cooldown:=1.0):
	scene = _scene
	cooldown = _cooldown
	cast_conditions = _cast_conditions
