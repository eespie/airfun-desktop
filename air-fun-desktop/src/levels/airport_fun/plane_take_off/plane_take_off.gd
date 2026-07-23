extends Node2D

@onready var state_machine: Node = %StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.init()

func _process(delta):
	state_machine.process_frame(delta)
	
func _physics_process(delta):
	state_machine.process_physics(delta)
	
func _input(event):
	state_machine.process_input(event)
