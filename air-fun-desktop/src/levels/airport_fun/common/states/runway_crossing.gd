extends State

@onready var taxi: State = %Taxi

var next_state

func enter() -> void:
	EventBus.sigConsoleAddCommand.emit(context.plane_id, context.plane_color, "Holding position", "Cross Runway", "Cleared to Cross Runway", EventBus.sigCommandCrossRunway)
	EventBus.sigCommandCrossRunway.connect(_on_command_cross_runway)
	next_state = null
	
func exit() -> void:
	EventBus.sigCommandCrossRunway.disconnect(_on_command_cross_runway)
	
func process_frame(_delta: float) -> State:
	return next_state

func _on_command_cross_runway(id: int) -> void:
	if context.plane_id != id:
		return
	next_state = taxi
