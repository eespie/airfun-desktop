extends State

# Prepare flight during this state
# select runway for taxi
# select destination after takeoff

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
