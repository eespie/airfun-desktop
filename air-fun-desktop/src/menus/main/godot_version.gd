extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature('release'):
		queue_free()
	else:
		text = "Godot %s" % Engine.get_version_info().string
