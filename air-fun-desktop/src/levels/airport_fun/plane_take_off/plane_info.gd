extends Node

var plane_id: int
var airport: Node2D
var plane_color: Color
var parking_slot
var selected_runway = null
var curr_taxi_path: int = 0
var selected: bool = false
var flight_curve: Curve2D

var start_time: float
var taxi_time: float
var expected_taxi_duration: float
var flight_time: float
var expected_flight_duration: float

var taxi_speed: float = 20

func init(id: int, current_airport: Node2D, slot: int) -> void:
	plane_id = id
	airport = current_airport
	parking_slot = slot
	plane_color = Global.get_plane_color(id)
	start_time = Time.get_ticks_msec()
	EventBus.sigPlaneSelect.connect(_on_plane_select)
	EventBus.sigPlaneTakeoff.connect(_on_plane_takeoff)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)


func get_slot_pos() -> Vector2:
	return airport.get_slot_pos(parking_slot)

func _on_plane_select(is_selected: bool, id: int):
	if id == plane_id:
		selected = is_selected

func smooth_curve():
	var point_count = flight_curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		flight_curve.set_point_in(i, -spline)
		flight_curve.set_point_out(i, spline)

func _get_spline(i):
	var last_pt = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_pt.direction_to(next_point) * 10
	return spline

func _get_point(i):
	i = clampi(i, 0, flight_curve.get_point_count() - 1)
	return flight_curve.get_point_position(i)

func _on_plane_takeoff(id: int):
	if id == plane_id:
		taxi_time = Time.get_ticks_msec()

func _on_plane_arrived(id: int):
	if id == plane_id:
		flight_time = Time.get_ticks_msec()
		#total_duration = snapped((Time.get_ticks_msec() - start_time) / 1000.0, 0.1)
	
