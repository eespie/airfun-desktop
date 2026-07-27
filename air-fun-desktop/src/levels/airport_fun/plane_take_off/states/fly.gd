extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane
@onready var trajectory: Line2D = %Trajectory

var curve: Curve2D
var progress: float
var next_state

func enter() -> void:
	curve = context.flight_curve
	next_state = null
	path_2d.set_curve(curve)
	path_follow_2d.set_progress(0)
	progress = 0.0
	plane.allow_collisions(true, false)

	
func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	
	progress += delta * plane.plane_speed
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
