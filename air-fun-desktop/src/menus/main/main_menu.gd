extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_random_fun_pressed() -> void:
	Global.game_mode = "random_fun"
	# res://src/core/main_game/main_game.tscn
	EventBus.sigChangeScene.emit("uid://dpx5o0r55oxb7")


func _on_airport_fun_pressed() -> void:
	Global.game_mode = "airport_fun"
	# res://src/core/main_game/main_game.tscn
	EventBus.sigChangeScene.emit("uid://dbu033tn423er")
