extends State

var next_state = null

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_frame(_delta: float) -> State:
	return next_state
