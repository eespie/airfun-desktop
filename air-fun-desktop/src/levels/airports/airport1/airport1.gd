extends Node2D

@onready var data: Node = %Data

func get_available_parking_slot():
	return data.get_available_parking_slot()

func set_parking_slot_available(slot) -> void:
	data.parking_slots_status[slot] = data.ParkingStatus.AVAILABLE

func get_slot_pos(slot) -> Vector2:
	return data.get_slot_pos(slot)

func select_runway_from_position(pos: Vector2):
	return data.select_runway_from_position(pos)

func change_visibility_of_all_runway_selectors(is_visible: bool) -> void:
	data.change_visibility_of_all_runway_selectors(is_visible)

func get_takeoff_pos(rw) -> Vector2:
	return data.get_takeoff_pos(rw)

func show_takeoff_point(rw) -> void:
	data.show_takeoff_point(rw)
	
func hide_takeoff_point(rw) -> void:
	data.hide_takeoff_point(rw)

func get_taxi_pathes(slot, rw) -> Array:
	return data.get_taxi_pathes(slot, rw)

func get_align_path(rw) -> Path2D:
	return data.get_align_path(rw)

func get_takeoff_path(rw) -> Path2D:
	return data.get_takeoff_path(rw)
