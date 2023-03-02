extends Node

## Collection of all the spells, their levels and upgrades

var _spell_collection := {
	# TODO - also pass levels and their specific upgrades
	magic_missile = Spell.new(
		preload("res://scenes/game/particles/magic_missile/magic_missile.tscn"),
		{max_distance = 128}, #visible_target = true}, # TODO
		1.0
	),
}


func get_spell(spell_name: StringName) -> Spell:
	if _spell_collection.has(spell_name):
		return _spell_collection[spell_name]
	
	return null
