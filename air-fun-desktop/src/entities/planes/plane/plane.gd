extends Node2D

const A_321 = preload("uid://tpcm05wk1rxs")
const A_380 = preload("uid://ckkvunftlok22")
const CONCORDE = preload("uid://ohhdxxql7vpr")
const Q_400 = preload("uid://cp5gjyjjl6cep")

const PLANE_MODELS = [A_321, A_380, CONCORDE, Q_400]

@onready var model: Node2D = %Model
@onready var select_plane: Sprite2D = %SelectPlane
@onready var highlight_plane: Sprite2D = %HighlightPlane

var plane_id :int = 0
var plane_model

func _ready() -> void:
	_bind_events()
	
func _bind_events():
	pass
	
func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func set_model(type : int):
	type = clampi(type, 0, PLANE_MODELS.size() - 1)
	plane_model = PLANE_MODELS[type].instantiate()
	model.add_child(plane_model)
	select_plane.scale = Vector2(plane_model.plane_select_scale, plane_model.plane_select_scale)
	highlight_plane.scale = Vector2(plane_model.plane_select_scale, plane_model.plane_select_scale)
	

func allow_collisions(flag : bool):
	plane_model.allow_collisions(flag)

func set_color(color : Color):
	plane_model.set_color(color)

func highlight(flag : bool):
	if flag:
		highlight_plane.show()
	else:
		highlight_plane.hide()
