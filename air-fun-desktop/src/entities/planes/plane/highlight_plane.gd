extends Sprite2D

var angle : float = 0.0

func _process(delta):
	angle += delta * 5.0
	var transparency = sin(angle) * 0.4 + 0.6
	modulate = Color(1.0, 1.0, 1.0, transparency) 
