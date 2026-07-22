extends Sprite2D

@onready var warning_sfx: AudioStreamPlayer2D = %WarningSFX

var plane_id :int = 0
var angle: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	EventBus.sigPlaneWarningStart.connect(_on_plane_warning_start)
	EventBus.sigPlaneWarningEnd.connect(_on_plane_warning_end)

func _process(delta):
	angle += delta * 5.0
	var transparency = sin(angle) * 0.4 + 0.6
	self_modulate = Color(1.0, 0, 0, transparency) 

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func _on_plane_warning_start(id: int):
	if plane_id == id:
		self.visible = true
		if not warning_sfx.playing:
			Sound.play_sfx(warning_sfx)

func _on_plane_warning_end(id: int):
	if plane_id == id:
		self.visible = false
		if warning_sfx.playing:
			warning_sfx.stop()
