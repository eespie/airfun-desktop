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


func _on_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	EventBus.sigPlaneWarningStart.emit(plane_id)


func _on_area_shape_exited(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	EventBus.sigPlaneWarningEnd.emit(plane_id)
