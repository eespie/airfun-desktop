extends Label

var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bind_events()
	
func _bind_events():
	EventBus.sigMessageDisplay.connect(_on_message_display)

func _on_message_display(message: String, color: Color):
	text = message
	modulate = color
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 8.0)
