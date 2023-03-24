extends Node

# TODO - load from local
@export var picked_spells = ["fire_ball", "magic_missile"]
@export var global_energy := 0.0  # TEMP


# TEST
func add_energy(energy: float) -> void:
	global_energy += energy
	print("(✨ energy from run: ", energy, ")")
	print("(✨ global energy: ", global_energy, ")")


func create_timer(
	callback: Callable, cooldown: float, is_one_shot := true, timer_name := ""
) -> Timer:
	var timer := Timer.new()

	timer.timeout.connect(callback)
	timer.wait_time = cooldown
	timer.one_shot = is_one_shot

	if timer_name:
		timer.name = timer_name

	return timer


func create_circle_area(radius: float, layer := 0, mask := 0, area_name := "") -> Area2D:
	var area := Area2D.new()

	area.collision_layer = layer
	area.collision_mask = mask

	var circle_shape := CircleShape2D.new()
	circle_shape.radius = radius

	var collision_shape := CollisionShape2D.new()
	collision_shape.shape = circle_shape

	if area_name:
		area.name = area_name
		collision_shape.name = area_name + "Collision"

	area.add_child(collision_shape)

	return area
