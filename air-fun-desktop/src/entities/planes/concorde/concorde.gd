extends Area2D

@export var plane_speed : int
@export var plane_select_scale : float = 1.0

@onready var plane_image: Sprite2D = %PlaneImage
@onready var plane_warning: Area2D = %PlaneWarning

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

func allow_collisions(flag: bool):
	monitorable = flag
	monitoring = flag
	plane_warning.monitorable = flag
	plane_warning.monitoring = flag

func set_color(color : Color):
	plane_image.modulate = color
