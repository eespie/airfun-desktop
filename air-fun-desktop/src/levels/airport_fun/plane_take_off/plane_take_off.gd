extends Node2D

@onready var state_machine: StateMachine = %StateMachine
@onready var plane_info: Node = %PlaneInfo
@onready var plane: Node2D = %Plane
@onready var parked: State = %Parked

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.init(plane_info)
	
func init(id: int, airport: Node2D, slot: String, type: int)-> void:
	plane.set_model(type)
	plane_info.init(id, airport, slot)
	state_machine.change_state(parked)

func _process(delta):
	state_machine.process_frame(delta)
	
func _physics_process(delta):
	state_machine.process_physics(delta)
	
func _input(event):
	state_machine.process_input(event)
