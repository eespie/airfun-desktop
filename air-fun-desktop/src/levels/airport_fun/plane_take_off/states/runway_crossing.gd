extends State

var next_state

func enter() -> void:
	next_state = null
	
func exit() -> void:
	pass
	
func process_frame(_delta: float) -> State:
	return next_state
