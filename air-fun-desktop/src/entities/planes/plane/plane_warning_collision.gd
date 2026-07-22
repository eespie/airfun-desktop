extends Area2D


var plane_id :int = 0

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

# Warning collision
func _on_area_entered(_area):
	EventBus.sigPlaneWarningStart.emit(plane_id)


func _on_area_exited(_area):
	EventBus.sigPlaneWarningEnd.emit(plane_id)
