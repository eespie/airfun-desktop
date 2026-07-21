extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# you need to enable "Advanced Settings" to make this property visible
	var game_name = ProjectSettings.get_setting("application/config/name")
	var ver = ProjectSettings.get_setting("application/config/version")
	var mode = "debug" if OS.is_debug_build() else "release"
	text =  "%s %s (%s)" % [game_name, ver, mode]
