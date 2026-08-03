extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane
@onready var trajectory: Line2D = %Trajectory
@onready var plane_info: Node = %PlaneInfo

# States
@onready var landing: State = %Landing

var next_state
var airport
var progress: float
var curve: Curve2D
var last_point: Vector2 = Vector2(0, 0)
@export var segment_length = 30

enum FlightPlan {WAITING, DRAW, READY_TO_LAND}
var flight_plan: FlightPlan

func enter() -> void:
	next_state = null
	airport = context.airport
	curve = plane_info.wait_landing.get_curve()
	path_2d.set_curve(curve)
	path_follow_2d.set_progress(0)
	progress = 0.0
	plane.allow_collisions(true, false)
	plane.highlight(true)
	flight_plan = FlightPlan.WAITING
	EventBus.sigPlaneSelect.connect(_on_plane_selected)
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_released)
	
func exit() -> void:
	EventBus.sigPlaneSelect.disconnect(_on_plane_selected)
	
func process_frame(_delta: float) -> State:
	match flight_plan:
		FlightPlan.WAITING:
			var curve_len = curve.get_baked_length()
			if curve_len < 2:
				return
			
			progress += _delta * plane.plane_speed
			if progress > curve_len:
				progress = curve_len
				EventBus.sigPlaneCrashed.emit(context.plane_id)
			path_follow_2d.set_progress(progress)
		
		FlightPlan.DRAW:
			trajectory.clear_points()
			var points = context.flight_curve.get_baked_points()
			var curve_index: int = points.size()
			while curve_index > 0:
				curve_index -= 1
				trajectory.add_point(points[curve_index])

		FlightPlan.READY_TO_LAND:
			next_state = landing
			
	return next_state
	
func _on_mouse_drag(_mouse_pos: Vector2) -> void:
	if flight_plan != FlightPlan.DRAW:
		return
		
	# Mouse arrive on target
	var rw = airport.select_runway_from_position(_mouse_pos)
	if rw:
		context.selected_runway = rw
		context.flight_curve.add_point(airport.get_runway_target(rw).global_position)
		context.smooth_curve()
		flight_plan = FlightPlan.READY_TO_LAND
		EventBus.sigTargetSelect.emit(false, context.plane_id)
		airport.change_visibility_of_all_runway_selectors(false)
		return
		
	if last_point.distance_to(_mouse_pos) < segment_length:
		return
	last_point = _mouse_pos
	
	context.flight_curve.add_point(_mouse_pos)
	context.smooth_curve()
		
func _on_mouse_released(_mouse_pos: Vector2) -> void:
	if flight_plan == FlightPlan.DRAW:
		flight_plan = FlightPlan.WAITING
		trajectory.clear_points()
		EventBus.sigPlaneSelect.emit(false, context.plane_id)

func _on_plane_selected(selected :bool, id :int) -> void:
	if context.plane_id != id:
		return
	plane.highlight(not selected)
	if selected:
		airport.change_visibility_of_all_runway_selectors(true)
		context.flight_curve = Curve2D.new()
		context.flight_curve.clear_points()
		context.flight_curve.bake_interval = segment_length
		context.flight_curve.add_point(plane.global_position)
		flight_plan = FlightPlan.DRAW
