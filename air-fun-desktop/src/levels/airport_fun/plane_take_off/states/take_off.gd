extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane
@onready var curves: Node = %Curves

# States
@onready var fly: State = %Fly

var progress: float = 0.0
var curve: Curve2D
var next_state

func enter() -> void:
	next_state = null
	var rw = context.selected_runway_name
	var takeoff_path = context.airport.TAKEOFF_BY_RW[rw]
	curve = ResourceLoader.load(takeoff_path, "Curve2D")
	path_2d.set_curve(curve)
	path_follow_2d.set_progress(0)
	progress = 0
	plane.position = Vector2(0, 0)
	
func exit() -> void:
	pass

func get_plane_takeoff_speed() -> float:
	return curves.get_takeoff_speed(path_follow_2d.get_progress_ratio()) * (plane.plane_speed - context.taxi_speed) + context.taxi_speed
	
func process_frame(delta: float) -> State:
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	
	progress += delta * get_plane_takeoff_speed()
	if progress > curve_len:
		next_state = fly

	path_follow_2d.set_progress(progress)
	
	return next_state
