extends Node

var plane_id: int
var airport: Node2D
var parking_slot: String
var plane_color: Color

func init(id: int, current_airport: Node2D, slot: String) -> void:
	plane_id = id
	airport = current_airport
	parking_slot = slot
	plane_color = Global.get_plane_color(id)

func get_slot_pos() -> Vector2:
	return airport.get_slot_pos(parking_slot)
