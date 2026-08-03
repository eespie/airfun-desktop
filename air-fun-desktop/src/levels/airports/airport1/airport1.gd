extends Node2D

@onready var data: Node = %Data

func get_available_parking_slot():
	return data.get_available_parking_slot()

func set_parking_slot_available(slot: int) -> void:
	data.parking_slots_status[slot] = data.ParkingStatus.AVAILABLE

func get_slot_pos(slot: int) -> Vector2:
	return data.get_slot_pos(slot)

func select_runway_from_position(pos: Vector2):
	return data.select_runway_from_position(pos)

func get_runway_target(_rw: int) -> Sprite2D:
	return data.get_runway_target(_rw)

func change_visibility_of_all_runway_selectors(_is_visible: bool) -> void:
	data.change_visibility_of_all_runway_selectors(_is_visible)
	
func change_color_of_slot(_slot: int, _color: Color) -> void:
	data.change_color_of_slot(_slot, _color)

func get_takeoff_pos(rw) -> Vector2:
	return data.get_takeoff_pos(rw)

func show_takeoff_point(rw) -> void:
	data.show_takeoff_point(rw)
	
func hide_takeoff_point(rw) -> void:
	data.hide_takeoff_point(rw)

func get_taxi_pathes(slot: int, rw) -> Array:
	return data.get_taxi_pathes(slot, rw)

func get_align_path(rw) -> Path2D:
	return data.get_align_path(rw)

func get_takeoff_path(rw) -> Path2D:
	return data.get_takeoff_path(rw)

func get_rand_plane_model(offset: int) -> int:
	return data.get_rand_plane_model(offset)

func get_wait_for_landing_path() -> Array[Path2D]:
	return data.get_wait_for_landing_path()
