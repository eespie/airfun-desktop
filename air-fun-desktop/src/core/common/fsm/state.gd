# Class to extend when implementing FSM states
class_name State
extends Node

var context : Node

func set_context(ctx : Node) -> void:
	context = ctx

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> State:
	return null
	
func process_physics(_delta: float) -> State:
	return null
	
func process_frame(_delta: float) -> State:
	return null
