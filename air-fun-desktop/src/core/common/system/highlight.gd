extends Sprite2D

@onready var curves: Node = %Curves

func _process(_delta):
	modulate = Color(1.0, 1.0, 1.0, curves.get_pulse()) 
