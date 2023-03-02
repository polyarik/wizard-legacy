extends Node

## Collection of all the spells in the game
##   their levels and upgrades

var _spell_collection := {
	magic_missile = [
		{
			cast_conditions = [""],
			cooldown = 1.0,
			scene = preload("res://scenes/game/particles/magic_missile/magic_missile.tscn")
			# TODO - add some scene tweaks parameter to pass arguments in an instance constructor
		},
	],
}

func get_spell(spell_name, lvl:=0) -> Dictionary:
	if _spell_collection.has(spell_name) and lvl < len(_spell_collection[spell_name]):
		return _spell_collection[spell_name][lvl]

	return {}
