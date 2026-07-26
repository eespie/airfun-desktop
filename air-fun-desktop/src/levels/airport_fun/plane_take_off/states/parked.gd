extends State

# Prepare flight during this state
# select runway for taxi
# select destination after takeoff

@onready var plane: Node2D = %Plane

func enter() -> void:
	plane.global_position = context.get_slot_pos()
	
func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> State:
	return null
	
func process_physics(_delta: float) -> State:
	return null
	
func process_frame(_delta: float) -> State:
	return null
