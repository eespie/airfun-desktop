extends Node2D

@onready var state_machine: StateMachine = %StateMachine
@onready var plane_info: Node = %PlaneInfo
@onready var plane: Node2D = %Plane
@onready var parked: State = %Parked
@onready var target: Area2D = %Target
@onready var trajectory: Line2D = %Trajectory

var plane_selected: int = 0
var plane_id: int = 0
var selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.init(plane_info)
	_bind_events()
	
func _bind_events():
	EventBus.sigPlaneReleased.connect(_on_plane_released)
	
func init(id: int, airport: Node2D, slot: int, plane_model: int, target_pos: Vector2)-> void:
	plane_id = id
	plane.set_model(plane_model)
	plane_info.init(id, airport, slot)
	plane.set_color(plane_info.plane_color)
	state_machine.change_state(parked)
	target.set_position(target_pos)
	target.set_color(plane_info.plane_color)
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
