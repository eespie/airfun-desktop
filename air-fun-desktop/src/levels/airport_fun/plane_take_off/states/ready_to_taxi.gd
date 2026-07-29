extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane
# States
@onready var taxi: State = %Taxi
@onready var parked: State = %Parked

var next_state
var mouse_clicked: bool

func enter() -> void:
	next_state = null
	mouse_clicked = false
	EventBus.sigPlaneSelect.emit(false, plane.plane_id)
	plane.highlight(true)
	var slot = context.parking_slot
	var rw = context.selected_runway
	var taxi_path: Path2D = context.airport.get_taxi_pathes(slot, rw)[0]
	path_2d.set_curve(taxi_path.curve)
	path_follow_2d.set_progress(0)
	plane.position = Vector2(0, 0)
	EventBus.sigConsoleAddCommand.emit(context.plane_id, context.plane_color, "Ready to taxi", EventBus.sigCommandTaxi)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigPlaneSelectedLong.connect(_on_plane_selected_long)
	EventBus.sigCommandTaxi.connect(_on_command_taxi)

	
func exit() -> void:
	context.curr_taxi_path = 0
	EventBus.sigMouseButtonClicked.disconnect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.disconnect(_on_mouse_button_released)
	EventBus.sigPlaneSelectedLong.disconnect(_on_plane_selected_long)
	EventBus.sigCommandTaxi.disconnect(_on_command_taxi)
	
func process_frame(_delta: float) -> State:
	path_follow_2d.set_progress(0)
	return next_state

func _on_mouse_button_clicked(mouse: Vector2):
	if plane.global_position.distance_to(mouse) > 32:
		return
	mouse_clicked = true
	plane.highlight(false)
	EventBus.sigPlaneSelectLongStart.emit(plane.plane_id)
	
func _on_mouse_button_released(_mouse: Vector2):
	if not mouse_clicked:
		return
	mouse_clicked = false
	EventBus.sigPlaneSelectLongStop.emit(plane.plane_id)
	
func _on_plane_selected_long(id: int):
	if id == context.plane_id:
		EventBus.sigConsoleRemoveCommand.emit(context.plane_id)
		next_state = taxi

func _on_command_taxi(id: int):
	if id == context.plane_id:
		plane.highlight(false)
		next_state = taxi
