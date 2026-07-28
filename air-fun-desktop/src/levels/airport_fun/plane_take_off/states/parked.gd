extends State

# Prepare flight during this state
# select runway for taxi
# select destination after takeoff

# Nodes
@onready var plane: Node2D = %Plane
@onready var target: Area2D = %Target
@onready var trajectory: Line2D = %Trajectory

# States
@onready var ready_to_taxi: State = %ReadyToTaxi

var next_state

var airport: Node2D
var last_point: Vector2 = Vector2(0, 0)

enum FlightPlan {PLANE, RUNWAY, TARGET, TARGET_DRAW, READY}
var flight_plan: FlightPlan

@export var segment_length = 30

func enter() -> void:
	flight_plan = FlightPlan.PLANE
	next_state = null
	airport = context.airport
	plane.global_position = context.get_slot_pos()
	plane.highlight(true)
	plane.allow_collisions(true, true)
	EventBus.sigPlaneSelect.connect(_on_plane_select)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	
func exit() -> void:
	EventBus.sigPlaneSelect.disconnect(_on_plane_select)
	EventBus.sigMouseButtonClicked.disconnect(_on_mouse_button_clicked)
	EventBus.sigMouseDrag.disconnect(_on_mouse_drag)
	EventBus.sigMouseButtonReleased.disconnect(_on_mouse_button_released)
	plane.highlight(false)
	
func process_frame(_delta: float) -> State:
	# Trajectory
	if flight_plan == FlightPlan.TARGET_DRAW:
		trajectory.clear_points()
		var points = context.flight_curve.get_baked_points()
		var curve_index: int = points.size()
		while curve_index > 0:
			curve_index -= 1
			trajectory.add_point(points[curve_index])
	if flight_plan == FlightPlan.READY:
		next_state = ready_to_taxi
	return next_state

func _on_plane_select(is_selected: bool, id: int):
	if not is_selected and context.plane_id == id and flight_plan == FlightPlan.PLANE:
		plane.highlight(true)
	
func _on_mouse_button_clicked(mouse: Vector2):
	match flight_plan:
		FlightPlan.TARGET:
			var departure_pos = airport.get_takeoff_pos(context.selected_runway)
			if departure_pos.distance_to(mouse) < 32:
				context.flight_curve = Curve2D.new()
				context.flight_curve.clear_points()
				context.flight_curve.bake_interval = segment_length
				context.flight_curve.add_point(departure_pos)
				last_point = mouse
				flight_plan = FlightPlan.TARGET_DRAW
				
		FlightPlan.RUNWAY:
			_select_runway(mouse)
			if context.selected_runway:
				airport.change_visibility_of_all_runway_selectors(false)
				airport.show_takeoff_point(context.selected_runway)
				EventBus.sigPlaneSelect.emit(false, context.plane_id)
				EventBus.sigTargetSelect.emit(true, context.plane_id)
				flight_plan = FlightPlan.TARGET
				
		FlightPlan.PLANE:
			if plane.global_position.distance_to(mouse) < 32:
				EventBus.sigPlaneUnselectAll.emit()
				EventBus.sigPlaneSelect.emit(true, context.plane_id)
				plane.highlight(false)
				airport.change_visibility_of_all_runway_selectors(true)
				target.show()
				flight_plan = FlightPlan.RUNWAY
				

func _on_mouse_drag(mouse: Vector2):
	if flight_plan != FlightPlan.TARGET_DRAW:
		return
	
		# Mouse arrive on target
	if target.position.distance_to(mouse) < 32:
		context.flight_curve.add_point(target.position)
		context.smooth_curve()
		flight_plan = FlightPlan.READY
		EventBus.sigTargetSelect.emit(false, context.plane_id)
		airport.hide_takeoff_point(context.selected_runway)
		return
		
	if last_point.distance_to(mouse) < segment_length:
		return
	last_point = mouse
	
	context.flight_curve.add_point(mouse)
	context.smooth_curve()
	
func _on_mouse_button_released(_mouse: Vector2):
	if flight_plan != FlightPlan.TARGET_DRAW:
		return
	context.flight_curve.clear_points()
	trajectory.clear_points()
	flight_plan = FlightPlan.TARGET

func _select_runway(mouse: Vector2) -> void:
	var rw = airport.select_runway_from_position(mouse)
	if rw:
		context.selected_runway = rw
