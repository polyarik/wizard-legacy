extends Node


func create_timer(callback: Callable, cooldown: float, is_one_shot:=true, timer_name:="") -> Timer:
	var timer := Timer.new()

	timer.timeout.connect(callback)
	timer.wait_time = cooldown
	timer.one_shot = is_one_shot

	if timer_name:
		timer.name = timer_name

	return timer
