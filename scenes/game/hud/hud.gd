class_name HUD
extends CanvasLayer


@onready var effects := {
	low_hp = $Effects/LowHP,
}
@onready var effects_animation_player := $Effects/EffectsAnimations as AnimationPlayer


func _ready():
	effects_animation_player.play("pulsing")

func _on_player_heath_changed(_old: float, new: float, max_health: float) -> void:
	if new <= 0 or new >= 0.3 * max_health:
		_set_effect("low_hp")
	else:
		var effect_value = (0.3 * max_health - new) / (0.3 * max_health)
		_set_effect("low_hp", effect_value)

func _set_effect(effect_name: StringName, value:=0.0) -> void:
	effects[effect_name].modulate.a = clamp(value, 0, 1)
