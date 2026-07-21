class_name MainGame
extends Node2D

@onready var level_root: Node2D = %LevelRoot

@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var game_over_root: Control = %GameOverRoot

const GAME_OVER = preload("uid://dqvnn2w00ddl1")
const HUD = preload("uid://blw2kf0lenpx8")
const PAUSED = preload("uid://cko02oljhiby")

var is_paused : bool = false

@export var initial_wait_time :float = 0.5

# Mouse
enum mouse_states {RELEASED, CLICKED}
var mouse_state: mouse_states = mouse_states.RELEASED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bind_events()
	init_hud()
	init_pause()
	init_game_over()
	EventBus.sigNewGame.emit(Global.game_mode)
	EventBus.sigNewPlanePop.emit(initial_wait_time)

func _bind_events() -> void:
	EventBus.sigGameOver.connect(_on_game_over)
	EventBus.sigPause.connect(_on_game_paused)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_state == mouse_states.CLICKED:
		EventBus.sigMouseDrag.emit(event.position)
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_state = mouse_states.CLICKED
			EventBus.sigMouseButtonClicked.emit(event.position)
		else:
			mouse_state = mouse_states.RELEASED
			EventBus.sigMouseButtonReleased.emit(event.position)
	if event.is_action_released("Pause"):
		EventBus.sigPause.emit(not is_paused)
		
func init_hud():
	hud_root.add_child(HUD.instantiate())
		
func init_pause():
	pause_root.add_child(PAUSED.instantiate())
	
func init_game_over():
	game_over_root.add_child(GAME_OVER.instantiate())

func toggle_pause_game():
	get_tree().paused = is_paused
	if is_paused:
		pause_root.show()
	else:
		pause_root.hide()

func _on_game_paused(is_paused : bool):
	self.is_paused = is_paused
	toggle_pause_game()


func _on_game_over() -> void:
	game_over_root.show()
