extends Node

## Collection of all the spells, their levels and upgrades

var _spell_collection := {
	magic_missile =
	{
		scene = preload("res://scenes/location/particles/magic_missile/magic_missile.tscn"),
		cooldown = 0.6,
		cast_time = 0.3,
		cast_conditions = {max_distance = 128},  #visible_target = true}, # TODO
		#target = closest
		#cooldown_coeff
		#levels / upgrades
	},
	fire_ball =
	{
		scene = preload("res://scenes/location/particles/fire_ball/fire_ball.tscn"),
		cooldown = 4.0,
		cast_time = 0.5,
		cast_conditions = {max_distance = 80},  #visible_target = true}, # TODO
		#target = closest
		#cooldown_coeff
		#levels / upgrades
	},
}


func get_spell(spell_name: StringName) -> Spell:
	var spell_data: Dictionary = _spell_collection.get(spell_name, {})

	if spell_data:
		return Spell.new(
			spell_data.scene, spell_data.cooldown, spell_data.cast_time, spell_data.cast_conditions
		)

	return null
