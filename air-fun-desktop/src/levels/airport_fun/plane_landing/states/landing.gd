extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane
@onready var trajectory: Line2D = %Trajectory
@onready var touchdown: State = %Touchdown

var next_state
var curve: Curve2D
var progress: float

func enter() -> void:
	curve = context.flight_curve
	next_state = null
	path_2d.set_curve(curve)
	path_follow_2d.set_progress(0)
	progress = 0.0
	
func exit() -> void:
	pass
	
func process_frame(_delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	
	progress += _delta * plane.plane_speed
	if progress > curve_len:
		next_state = touchdown
		return
	path_follow_2d.set_progress(progress)
	
		# Trajectory
	trajectory.clear_points()
	var points = curve.get_baked_points()
	var curve_index: int = points.size() - 2
	var trajectory_progress = curve.get_closest_offset(points[curve_index])
	while trajectory_progress > progress:
		curve_index -= 1
		trajectory.add_point(points[curve_index])
		trajectory_progress = curve.get_closest_offset(points[curve_index])
	
	return next_state
