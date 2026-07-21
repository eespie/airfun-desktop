extends Control

@onready var game_over_sfx: AudioStreamPlayer2D = %GameOverSFX

func _ready() -> void:
	Sound.play_sfx(game_over_sfx)

func _on_main_menu_pressed() -> void:
	var root = get_tree().get_root().get_tree()
	root.paused = false
	EventBus.sigChangeScene.emit("uid://cg4nt0v8d1n8f")
