extends Area2D

@onready var target_image: Sprite2D = %TargetImage

var plane_id :int = 0

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func _on_area_entered(area):
	if area.get_plane_id() == plane_id:
		EventBus.sigPlaneArrived.emit(plane_id) # Replace with function body.

func set_color(color : Color):
	target_image.modulate = color
