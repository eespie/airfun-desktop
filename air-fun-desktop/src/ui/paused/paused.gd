extends Control

func _ready() -> void:
	_bind_events()
	
func _bind_events():
	EventBus.sigPause.connect(_on_pause)

func _on_pause(is_paused : bool):
	if is_paused:
		Sound.play_sfx($PauseSFX)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	EventBus.sigPause.emit(false)
	EventBus.sigChangeScene.emit("uid://cg4nt0v8d1n8f")

func _on_resume_pressed() -> void:
	EventBus.sigPause.emit(false)
