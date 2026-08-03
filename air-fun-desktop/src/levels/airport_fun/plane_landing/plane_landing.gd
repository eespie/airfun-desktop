extends Node2D

@onready var plane_info: Node = %PlaneInfo
@onready var state_machine: StateMachine = %StateMachine
@onready var trajectory: Line2D = %Trajectory
@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var plane: Node2D = %Plane

# States
@onready var waiting_to_land: State = %WaitingToLand

var plane_id: int = 0

func _ready():
	state_machine.init(plane_info)
	_bind_events()
	
func _bind_events():
	EventBus.sigPlaneReleased.connect(_on_plane_released)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)

func init(id: int, airport: Node2D, slot: int, plane_model: int, wait_for_landing_path: Path2D)-> void:
	plane_id = id
	plane.set_model(plane_model)
	plane_info.init(id, airport, slot, wait_for_landing_path)
	plane.set_color(plane_info.plane_color)
	state_machine.change_state(waiting_to_land)
	trajectory.modulate = plane_info.plane_color
	propagate_call("set_plane_id", [id])

func _process(delta):
	state_machine.process_frame(delta)
	
func _physics_process(delta):
	state_machine.process_physics(delta)
	
func _input(event):
	state_machine.process_input(event)

func _on_plane_released(id: int):
	if plane_id == id:
		EventBus.sigAddScore.emit(1)
		queue_free()

func _on_mouse_button_clicked(mouse_pos: Vector2i):
	if plane.global_position.distance_to(mouse_pos) < 32:
		EventBus.sigPlaneSelect.emit(not plane.is_selected, plane_id)
