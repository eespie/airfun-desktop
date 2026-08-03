extends Node

enum PLANE {A321, A380, Concorde, Q400}
var allowed_plane_models: Array = [PLANE.A321, PLANE.Q400, PLANE.A380, PLANE.Concorde]

enum SLOT {none, slot1, slot2, slot3, slot4, slot5}
enum RUNWAY {none, rw1a, rw1b}

@export_group("Planes")
@export var expected_time_by_plane_type: Dictionary[PLANE, Dictionary] = {
	PLANE.A321: {"taxi":60.0, "flight":20.0},
	PLANE.Q400: {"taxi":60.0, "flight":40.0},
}

@export_group("Airport")
@export var select_parking_slot: Dictionary[SLOT, Sprite2D]
@export var select_runway: Dictionary[RUNWAY, Sprite2D]
@export var takeoff_point_by_runway: Dictionary[RUNWAY, Sprite2D]

@export_group("Path")
@export var path_align_by_runway:Dictionary[RUNWAY, Path2D]
@export var path_takeoff_by_runway:Dictionary[RUNWAY, Path2D]

@onready var path_taxi_by_slot_and_runway: Dictionary[SLOT, Dictionary] = {
	SLOT.slot1: {
		RUNWAY.rw1a: [%"Path Taxi 1 - 1"],
		RUNWAY.rw1b: [%"Path Taxi 2 - 1"]
	},
	SLOT.slot2: {
		RUNWAY.rw1a: [%"Path Taxi 1 - 2"],
		RUNWAY.rw1b: [%"Path Taxi 2 - 2"]
	},
	SLOT.slot3: {
		RUNWAY.rw1a: [%"Path Taxi 1 - 3"],
		RUNWAY.rw1b: [%"Path Taxi 2 - 3"]
	},
	SLOT.slot4: {
		RUNWAY.rw1a: [%"Path Taxi 1 - 4"],
		RUNWAY.rw1b: [%"Path Taxi 2 - 4"]
	},
	SLOT.slot5: {
		RUNWAY.rw1a: [%"Path Taxi 1 - 5"],
		RUNWAY.rw1b: [%"Path Taxi 2 - 5"]
	},
}

enum ParkingStatus {AVAILABLE, USED, UNAVAILABLE}

var parking_slots_status = {
	SLOT.slot1 : ParkingStatus.AVAILABLE,
	SLOT.slot2 : ParkingStatus.AVAILABLE,
	SLOT.slot3 : ParkingStatus.AVAILABLE,
	SLOT.slot4 : ParkingStatus.AVAILABLE,
	SLOT.slot5 : ParkingStatus.AVAILABLE,
}

@export_group("Landing")
@export var path_wait_for_landing: Array[Path2D]
@export var parking_slot_selection: Dictionary[SLOT, Sprite2D]

func get_available_parking_slot():
	var availabe_slots: Array = []
	for slot in parking_slots_status:
		if parking_slots_status[slot] == ParkingStatus.AVAILABLE:
			availabe_slots.append(slot)
	
	if availabe_slots.size() > 0:
		var slot = availabe_slots[randi_range(0, availabe_slots.size() - 1)]
		parking_slots_status[slot] = ParkingStatus.USED
		return slot
		
	return null

func get_slot_pos(_slot: int) -> Vector2:
	return select_parking_slot[_slot].global_position

func change_visibility_of_all_runway_selectors(_is_visible: bool) -> void:
	for rw in select_runway:
		select_runway[rw].visible = _is_visible
	
func select_runway_from_position(_pos: Vector2):
	for rw in select_runway:
		if select_runway[rw].global_position.distance_to(_pos) < 32:
			return rw
	return null

func get_runway_target(_rw: int) -> Sprite2D:
	return select_runway[_rw]

func get_takeoff_pos(_rw: int) -> Vector2:
	return takeoff_point_by_runway[_rw].global_position

func show_takeoff_point(_rw: int) -> void:
	takeoff_point_by_runway[_rw].show()
	
func hide_takeoff_point(_rw: int) -> void:
	takeoff_point_by_runway[_rw].hide()

func get_taxi_pathes(_slot: int, _rw: int) -> Array:
	return path_taxi_by_slot_and_runway[_slot][_rw]

func get_align_path(_rw: int) -> Path2D:
	return path_align_by_runway[_rw]
	
func get_takeoff_path(_rw: int) -> Path2D:
	return path_takeoff_by_runway[_rw]

func get_rand_plane_model(_offset: int) -> int:
	var count = allowed_plane_models.size()
	return allowed_plane_models[randi_range(0, count - 1)]

func get_wait_for_landing_path() -> Array[Path2D]:
	return path_wait_for_landing

func change_color_of_slot(_slot: int, _color: Color) -> void:
	for slot in parking_slot_selection:
		parking_slot_selection[slot].modulate = Color.TRANSPARENT
	
	parking_slot_selection[_slot].modulate = Color.WHITE
	parking_slot_selection[_slot].self_modulate = _color
