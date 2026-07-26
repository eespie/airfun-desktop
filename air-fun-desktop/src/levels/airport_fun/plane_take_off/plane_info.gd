extends Node

var plane_id: int
var airport: Node2D
var parking_slot: String
var plane_color: Color
var selected_runway_name = null
var curr_taxi_path: int = 0
var selected: bool = false
var flight_curve: Curve2D

func init(id: int, current_airport: Node2D, slot: String) -> void:
	plane_id = id
	airport = current_airport
	parking_slot = slot
	plane_color = Global.get_plane_color(id)
	EventBus.sigPlaneSelect.connect(_on_plane_select)

func get_slot_pos() -> Vector2:
	return airport.get_slot_pos(parking_slot)

func _on_plane_select(is_selected: bool, id: int):
	if id == plane_id:
		selected = is_selected
