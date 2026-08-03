extends State

@onready var plane: Node2D = %Plane
@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

# States
@onready var runway_crossing: State = %RunwayCrossing

var next_state
var curr_taxi_path: int
var curve: Curve2D
var progress: float

func enter() -> void:
	next_state = null
	curr_taxi_path = context.curr_taxi_path
	curve = path_2d.get_curve()
	progress = 0.0
	
func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	progress += delta * context.taxi_speed
	if progress > curve_len:
		curr_taxi_path += 1
		var slot = context.parking_slot
		context.airport.set_parking_slot_available(slot)
		var rw = context.selected_runway
		if curr_taxi_path != context.airport.get_taxi_pathes(slot, rw).size():
			context.curr_taxi_path = curr_taxi_path
			next_state = runway_crossing

	path_follow_2d.set_progress(progress)
	
	return next_state
