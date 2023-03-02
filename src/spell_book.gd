extends Node

## Collection of all the spells in the game
##   their levels and upgrades

var _spell_collection := {
	# TODO - also pass levels and their specific upgrades
	magic_missile = Spell.new(preload("res://scenes/game/particles/magic_missile/magic_missile.tscn"), [""], 1.0),
}

func get_spell(spell_name: StringName) -> Spell:
	if _spell_collection.has(spell_name):
		return _spell_collection[spell_name]
	
	return null
