class_name Spell

extends Area2D


var scene: PackedScene
var cast_conditions: Dictionary
var conditions_met: Dictionary
var cooldown: float
var on_cooldown := false

# TODO - add levels and their specific upgrades
# TODO - define target_type (group; nearest, strongest...)


func _init(_scene: PackedScene, _cast_conditions:={}, _cooldown:=1.0) -> void:
	scene = _scene
	cooldown = _cooldown

	for condition in _cast_conditions:
		var value = _cast_conditions[condition]
		
		cast_conditions[condition] = value
		conditions_met[condition] = false

func can_be_casted() -> bool:
	if on_cooldown:
		return false
	
	if cast_conditions:
		for condition_met in conditions_met.values():
			if not condition_met:
				return false

	return true

func cast() -> Node:
	on_cooldown = true
	return scene.instantiate()
