extends Node2D

@onready var mouse: StaticBody2D = %Mouse
@onready var airport_root: Node2D = %AirportRoot
@onready var planes_root: Node2D = %PlanesRoot
@onready var plane_pop_timer: Timer = %PlanePopTimer
@onready var game_over_timer: Timer = %GameOverTimer
@onready var curves: Node = %Curves

const PLANE_TAKE_OFF = preload("uid://b2r563y0n07br")

const AIRPORT_1 = preload("uid://c7e61voml44to")

const AIRPORTS = [
	AIRPORT_1
]

@export var current_airport :int = 0

var airport: Node2D
var plane_id: int = 0
var plane_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_airport()
	_bind_events()
	
func _bind_events() -> void:
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigNewPlaneTimer.connect(_on_new_plane_timer)
	EventBus.sigPlaneUnselectAll.connect(_on_unselect_all_planes)
	EventBus.sigPlaneCrashed.connect(_on_plane_crashed)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)

func _on_mouse_drag(mouse_pos: Vector2i):
	self.mouse.position = mouse_pos
	
func _on_mouse_button_clicked(mouse_pos: Vector2i):
	self.mouse.position = mouse_pos
	
func _on_mouse_button_released(_mouse: Vector2i):
	self.mouse.position = Vector2(-100, -100)

func init_airport() -> void:
	airport = AIRPORTS[current_airport].instantiate()
	airport_root.add_child(airport)
	
func _on_new_plane_timer(wait: float):
	if not plane_pop_timer.is_stopped():
		plane_pop_timer.stop()
	plane_pop_timer.start(wait)
	
func _on_plane_pop_timer_timeout() -> void:
	if plane_count > 14:
		EventBus.sigNewPlaneTimer.emit(randf() * curves.get_takeoff_wait_time(plane_id))
		return
		
	var slot = airport.get_available_parking_slot()
	if slot == null:
		# no avaliable slot
		EventBus.sigNewPlaneTimer.emit(randf() * curves.get_takeoff_wait_time(plane_id))
		return
	
	plane_id += 1
	plane_count += 1
	var plane = PLANE_TAKE_OFF.instantiate()
	planes_root.add_child(plane)
	var target_pos = _get_target_pos()
	var plane_model = airport.get_rand_plane_model(plane_id)
	plane.init(plane_id, airport, slot, plane_model, target_pos)
	
	EventBus.sigNewPlaneTimer.emit(curves.get_takeoff_wait_time(plane_id))

func _on_unselect_all_planes() -> void:
	for id in range(1, plane_id + 1):
		EventBus.sigPlaneSelect.emit(false, id)

func _on_plane_crashed(_id: int) -> void:
	if game_over_timer.is_stopped():
		game_over_timer.start(0.5)
	
func _on_game_over_timer_timeout() -> void:
	EventBus.sigGameOver.emit()

func _get_target_pos() -> Vector2:
	var side = randf()
	if side > 0.75:
		# top
		return Vector2(randi_range(100, 1820), 150)
	if side > 0.5:
		# left
		return Vector2(1820, randi_range(150, 980))
	if side > 0.25:
		# bottom
		return Vector2(randi_range(100, 1820), 980)
	# right
	return Vector2(100, randi_range(150, 980))

func _on_plane_arrived(_id: int) -> void:
	plane_count -= 1
