extends Control

@onready var plane_info: Button = %"PlaneInfo"
@onready var description: Button = %Description
@onready var elapsed_time: Label = %ElapsedTime
@onready var process: Button = %Process

var plane_id: int
var command_signal: Signal
var post_cmd_description: String
var start_time

func set_command(id: int, color: Color, desc: String, cmd: String, post_desc: String, sig: Signal) -> void:
	plane_id = id
	plane_info.text = "Plane " + str(plane_id)
	plane_info.modulate = color
	description.text = desc
	command_signal = sig
	process.text = cmd
	post_cmd_description = post_desc
	start_time = Time.get_ticks_msec()
	
func _on_process_pressed() -> void:
	command_signal.emit(plane_id)
	process.disabled = true
	description.disabled = true
	description.text = post_cmd_description

func _on_plane_info_pressed() -> void:
	EventBus.sigPlaneUnselectAll.emit()
	EventBus.sigPlaneSelect.emit(true, plane_id)

func _process(_delta: float) -> void:
	var current = Time.get_ticks_msec()
	var duration = floori((current - start_time) / 1000.0)
	var minutes = floori(duration / 60.0)
	var seconds = duration % 60
	elapsed_time.text = "%02d:%02d" % [minutes, seconds]
	
