extends Node

var WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
var HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")

var game_mode: String

var play_sfx = true
var play_music = true
var fullscreen = false

const PLANE_COLORS = [
	Color.CRIMSON,
	Color.BLUE,
	Color.GREEN,
	Color.DARK_SALMON,
	Color.BLUE_VIOLET,
	Color.WHITE_SMOKE,
	Color.VIOLET,
	Color.ORANGE,
	Color.YELLOW,
	Color.DEEP_PINK
]

func get_plane_color(id : int) -> Color:
	return PLANE_COLORS[id % PLANE_COLORS.size()]
