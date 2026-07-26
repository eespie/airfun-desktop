extends Node2D

@onready var parking_slot_1: Sprite2D = %ParkingSlot1
@onready var parking_slot_2: Sprite2D = %ParkingSlot2
@onready var parking_slot_3: Sprite2D = %ParkingSlot3
@onready var parking_slot_4: Sprite2D = %ParkingSlot4
@onready var parking_slot_5: Sprite2D = %ParkingSlot5

@onready var start_1: Sprite2D = %Start1
@onready var airborne_1: Sprite2D = %Airborne1
@onready var path_taxi_1___1: Path2D = %"Path Taxi 1 - 1"
@onready var path_align_1: Path2D = %"Path Align 1"
@onready var path_takeoff_1: Path2D = %"Path Takeoff 1"

@onready var start_2: Sprite2D = %Start2
@onready var airborne_2: Sprite2D = %Airborne2
@onready var path_taxi_2___1: Path2D = %"Path Taxi 2 - 1"
@onready var path_align_2: Path2D = %"Path Align 2"
@onready var path_takeoff_2: Path2D = %"Path Takeoff 2"


@onready var SELECT_PARKING = {
	"slot1" : parking_slot_1,
	"slot2" : parking_slot_2,
	"slot3" : parking_slot_3,
	"slot4" : parking_slot_4,
	"slot5" : parking_slot_5,
}

@onready var SELECT_RUNWAY = {
	"rw1a" : start_1,
	"rw1b" : start_2,
}

@onready var DEPARTURE_BY_RW = {
	"rw1a" : airborne_1,
	"rw1b" : airborne_2,
}

var TAXI_BY_SLOT_AND_RW = {
	"slot1" : {
		"rw1a" : ["res://resources/curves/airport1/path_taxi_1___1.tres"],
		"rw1b" : ["res://resources/curves/airport1/path_taxi_2___1.tres"],
	},
	"slot2" : {},
	"slot3" : {},
	"slot4" : {},
	"slot5" : {},
}

var ALIGN_BY_RW = {
	"rw1a" : "res://resources/curves/airport1/path_align_1.tres",
	"rw1b" : "res://resources/curves/airport1/path_align_2.tres",
}

var TAKEOFF_BY_RW = {
	"rw1a" : "res://resources/curves/airport1/path_takeoff_1.tres",
	"rw1b" : "res://resources/curves/airport1/path_takeoff_2.tres",
}

enum ParkingStatus {AVAILABLE, USED, UNAVAILABLE}

var parking_slots_status = {
	"slot1" : ParkingStatus.AVAILABLE,
	"slot2" : ParkingStatus.UNAVAILABLE,
	"slot3" : ParkingStatus.UNAVAILABLE,
	"slot4" : ParkingStatus.UNAVAILABLE,
	"slot5" : ParkingStatus.UNAVAILABLE,
}

func list_runway_to_select():
	return SELECT_RUNWAY

func get_available_parking_slot() -> String:
	for slot in parking_slots_status:
		if parking_slots_status[slot] == ParkingStatus.AVAILABLE:
			parking_slots_status[slot] = ParkingStatus.USED
			return slot
	return ""

func set_parking_slot_available(slot: String) -> void:
	parking_slots_status[slot] = ParkingStatus.AVAILABLE

func get_slot_pos(slot: String) -> Vector2:
	return SELECT_PARKING[slot].global_position

func change_visibility_of_all_runway_selectors(is_visible: bool) -> void:
	for rw in SELECT_RUNWAY:
		SELECT_RUNWAY[rw].visible = is_visible
