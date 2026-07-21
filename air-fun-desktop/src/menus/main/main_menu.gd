extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_random_fun_pressed() -> void:
	EventBus.sigChangeScene.emit("res://src/core/main_game/main_game.tscn")
