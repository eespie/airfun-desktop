extends Node2D

var plane_id :int = 0
var radius: float = 256.0
var progress: float = 0.0
var select_color: Color = Color.WHITE
var progress_tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bind_events()
	
func _bind_events() -> void:
	EventBus.sigPlaneSelectLongStart.connect(_on_plane_select_long_start)
	EventBus.sigPlaneSelectLongStop.connect(_on_plane_select_long_stop)
	
func set_plane_id(id: int):
	plane_id = id
	
# call queue_redraw() to update
func _draw() -> void:
	draw_arc(position, radius, 0.0, 2.0 * PI * progress, max(2, floori(progress * 50.0)), select_color, 20.0, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		queue_redraw()

func resize(ratio: float) -> void:
	radius *= ratio

func _on_plane_select_long_start(id: int):
	if id != plane_id:
		return
	progress = 0.0
	show()
	if progress_tween:
		progress_tween.kill()
	progress_tween = create_tween()
	progress_tween.tween_property(self, "progress", 1.0, 1.0)
	progress_tween.tween_callback(_long_selected)
	
func _long_selected():
	hide()
	EventBus.sigPlaneSelectedLong.emit(plane_id)
	
func _on_plane_select_long_stop(id: int):
	if id != plane_id:
		return
	hide()
	if progress_tween:
		progress_tween.kill()
