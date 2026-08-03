extends Node

@export var pulse_curve : Curve
@export var takeoff_curve : Curve
@export var takeoff_wait_time_curve: Curve

func get_pulse() -> float:
	var step = Time.get_ticks_usec() / 1000000.0
	var offset = step - floorf(step)
	var value = pulse_curve.sample_baked(offset)
	
	return value

func get_takeoff_speed(offset: float) ->float:
	return takeoff_curve.sample_baked(offset)

func get_next_plane_wait_time(plane_number: int) -> float:
	return 10.0 + takeoff_wait_time_curve.sample_baked(plane_number / 2.0)
