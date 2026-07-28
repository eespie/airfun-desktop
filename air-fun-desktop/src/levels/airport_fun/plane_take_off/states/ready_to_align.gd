extends State

@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane

# States
@onready var align: State = %Align

var mouse_clicked: bool = false
var next_state = null

func enter() -> void:
	var rw = context.selected_runway
	var align_path = context.airport.get_align_path(rw)
	path_2d.set_curve(align_path.curve)
	path_follow_2d.set_progress(0)
	plane.position = Vector2(0, 0)
	var message = "Plane {0} ready to takeoff".format([context.plane_id])
	EventBus.sigMessageDisplay.emit(message, context.plane_color)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigPlaneSelectedLong.connect(_on_plane_selected_long)
	
func exit() -> void:
	EventBus.sigMouseButtonClicked.disconnect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.disconnect(_on_mouse_button_released)
	EventBus.sigPlaneSelectedLong.disconnect(_on_plane_selected_long)
	
func process_frame(_delta: float) -> State:
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
		next_state = align
