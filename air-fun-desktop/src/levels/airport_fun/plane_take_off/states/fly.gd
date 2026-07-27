extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane

var curve: Curve2D
var progress: float
var next_state

func enter() -> void:
	curve = context.flight_curve
	next_state = null
	path_2d.set_curve(curve)
	path_follow_2d.set_progress(0)
	progress = 0.0
	
func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	
	progress += delta * plane.plane_speed
	path_follow_2d.set_progress(progress)
	
	return next_state
