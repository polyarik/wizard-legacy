extends Node

@export var is_active := true


func _on_home_returned() -> void:
	if not is_active:
		return

	print("> HOME :3")


func _on_location_started(location_name: String) -> void:
	if not is_active:
		return

	print("> LOCATION: ", location_name)


func _on_player_health_changed(_change: float, health: float, max_health: float) -> void:
	if not is_active:
		return

	if health < max_health:
		print("💔 player health: {current}/{max}".format({"current": health, "max": max_health}))
	else:
		print("❤️ player health: {current}/{max}".format({"current": health, "max": max_health}))


func _on_player_died(energy: float) -> void:
	if not is_active:
		return

	# TEMP (global_energy)
	print(
		"💀 player died with {current} energy | total: {total}".format(
			{"current": energy, "total": Globals.global_energy + energy}
		)
	)
