extends Node

var plane_id: int
var airport: Node2D
var plane_color: Color
var parking_slot
var selected_runway = null
var curr_taxi_path: int = 0
var selected: bool = false
var flight_curve: Curve2D
var wait_landing: Path2D

var taxi_speed: float = 20

func init(id: int, current_airport: Node2D, slot: int, wait_for_landing_path: Path2D) -> void:
	plane_id = id
	airport = current_airport
	parking_slot = slot
	plane_color = Global.get_plane_color(id)
	wait_landing = wait_for_landing_path
	EventBus.sigPlaneSelect.connect(_on_plane_select)

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
