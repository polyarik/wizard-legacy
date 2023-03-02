extends Node

## 

var spell_book: SpellBook
var location: Node2D
var player: PlayerCharacter
# TODO - enemy spawn settings


func _ready():
	spell_book = get_node("/root/SpellBook")

	location = get_tree().get_first_node_in_group("Location")
	player = location.get_tree().get_first_node_in_group("Player")

	# TODO - only pass the picked spells to the player
	var spells: Array[Spell] = [
		spell_book.get_spell("magic_missile")
	]

	player.learn_spells(spells)
