extends Area2D

var plane_id :int = 0

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

# plane collision
func _on_area_entered(_area):
	EventBus.sigPlaneCrashed.emit(plane_id)


func _on_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	EventBus.sigPlaneCrashed.emit(plane_id)
