extends Node

@export var pulse_curve : Curve

func get_pulse() -> float:
	var step = Time.get_ticks_usec() / 1000000.0
	var offset = step - floorf(step)
	var value = pulse_curve.sample_baked(offset)
	
	return value
