class_name MainGame
extends Node2D

@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
