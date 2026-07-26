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

enum FlightPlan {PLANE, RUNWAY, TARGET, TARGET_DRAW, READY}
var flight_plan: FlightPlan

@export var segment_length = 30

func enter() -> void:
	flight_plan = FlightPlan.PLANE
	next_state = null
	airport = context.airport
	plane.global_position = context.get_slot_pos()
	plane.highlight(true)
	EventBus.sigPlaneSelect.connect(_on_plane_select)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	
func exit() -> void:
	EventBus.sigPlaneSelect.disconnect(_on_plane_select)
	EventBus.sigMouseButtonClicked.disconnect(_on_mouse_button_clicked)
	plane.highlight(false)
	
func process_frame(_delta: float) -> State:
	# Trajectory
	trajectory.clear_points()
	if flight_plan == FlightPlan.TARGET_DRAW:
		trajectory.show()
		var points = context.flight_curve.get_baked_points()
		var curve_index: int = points.size() - 2
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
			var departure_pos = airport.DEPARTURE_BY_RW[context.selected_runway_name].global_position
			if departure_pos.distance_to(mouse) < 32:
				context.flight_curve = Curve2D.new()
				context.flight_curve.clear_points()
				context.flight_curve.bake_interval = segment_length
				context.flight_curve.add_point(departure_pos)
				flight_plan = FlightPlan.TARGET_DRAW
				
		FlightPlan.RUNWAY:
			_select_runway(mouse)
			if context.selected_runway_name:
				airport.change_visibility_of_all_runway_selectors(false)
				airport.DEPARTURE_BY_RW[context.selected_runway_name].show()
				target.show()
				EventBus.sigPlaneSelect.emit(false, context.plane_id)
				EventBus.sigTargetSelect.emit(true, context.plane_id)
				flight_plan = FlightPlan.TARGET
				
		FlightPlan.PLANE:
			if plane.global_position.distance_to(mouse) < 32:
				EventBus.sigPlaneUnselectAll.emit()
				EventBus.sigPlaneSelect.emit(true, context.plane_id)
				plane.highlight(false)
				airport.change_visibility_of_all_runway_selectors(true)
				flight_plan = FlightPlan.RUNWAY
				

func _select_runway(mouse: Vector2) -> void:
	for rw in airport.SELECT_RUNWAY:
		if airport.SELECT_RUNWAY[rw].global_position.distance_to(mouse) < 32:
			context.selected_runway_name = rw
