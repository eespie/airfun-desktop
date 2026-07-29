extends Control

@onready var command_list: VBoxContainer = %CommandList

const COMMAND = preload("uid://djb1vlvm632gg")

var cmd_list: Dictionary[int, Control]

func _ready() -> void:
	_bind_events()
	
func _bind_events() -> void:
	EventBus.sigConsoleAddCommand.connect(_on_add_command)
	EventBus.sigConsoleRemoveCommand.connect(_on_remove_command)

func _on_add_command(id: int, color: Color, command: String, sig: Signal) -> void:
	var cmd = COMMAND.instantiate()
	command_list.add_child(cmd)
	cmd.set_command(id, color, command, sig)
	cmd_list[id] = cmd

func _on_remove_command(id: int) -> void:
	if cmd_list.has(id):
		var cmd = cmd_list[id]
		cmd_list.erase(id)
		cmd.queue_free()
