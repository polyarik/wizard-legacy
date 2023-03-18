class_name HUD
extends CanvasLayer

@onready var effects := {
	low_hp = $Effects/LowHP,
}
@onready var effects_animation_player := $Effects/EffectsAnimations as AnimationPlayer
# TODO? - or implement Camera class with "target"
@onready var player_character := get_node("../Characters/Player") as PlayerCharacter


func _ready() -> void:
	player_character.health_changed.connect(_on_player_heath_changed)
	effects_animation_player.play("pulsing")


func _on_player_heath_changed(_change: float, health: float, max_health: float) -> void:
	if health <= 0 or health >= max_health * 0.3:
		_set_effect("low_hp")
	else:
		var effect_value = (max_health * 0.3 - health) / (max_health * 0.3)
		_set_effect("low_hp", effect_value)


func _set_effect(effect_name: StringName, value := 0.0) -> void:
	effects[effect_name].modulate.a = clamp(value, 0, 1)
