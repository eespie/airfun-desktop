extends Area2D

@export var plane_speed : int
@export var plane_select_scale : float = 1.0

@onready var plane_image: Sprite2D = %PlaneImage
@onready var plane_warning: Area2D = %PlaneWarning
@onready var plane_collision: CollisionPolygon2D = %PlaneCollision

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

func allow_collisions(flag: bool, is_grounded: bool = false):
	monitorable = flag
	monitoring = flag
	if is_grounded:
		set_collision_layer(16)
		set_collision_mask(16)
		plane_warning.monitorable = false
		plane_warning.monitoring = false
	else:
		set_collision_layer(1)
		set_collision_mask(1)
		plane_warning.monitorable = flag
		plane_warning.monitoring = flag
		
func set_color(color : Color):
	plane_image.modulate = color


func _on_mouse_entered() -> void:
	EventBus.sigMouseOverPlaneStart.emit(plane_id)


func _on_mouse_exited() -> void:
	EventBus.sigMouseOverPlaneStop.emit(plane_id)
