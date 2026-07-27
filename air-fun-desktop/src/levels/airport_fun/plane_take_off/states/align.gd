extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane

# States
@onready var take_off: State = %TakeOff

var curve: Curve2D
var progress: float = 0.0

var next_state

func enter() -> void:
	next_state = null
	curve = path_2d.get_curve()
	
func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	progress += delta * context.taxi_speed
	if progress > curve_len:
		next_state = take_off

	path_follow_2d.set_progress(progress)
	
	return next_state
