extends State

var next_state

func enter() -> void:
	var message = "Plane {0} waiting to cross runway".format([context.plane_id])
	EventBus.sigMessageDisplay.emit(message, context.plane_color)
	next_state = null
	
func exit() -> void:
	pass
	
func process_frame(_delta: float) -> State:
	return next_state
