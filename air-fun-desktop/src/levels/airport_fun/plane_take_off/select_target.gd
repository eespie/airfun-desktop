extends Sprite2D

var plane_id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	EventBus.sigTargetSelect.connect(_on_target_select)

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func _on_target_select(selected: bool, id: int):
	if plane_id == id:
		if selected:
			show()
		else:
			hide()
