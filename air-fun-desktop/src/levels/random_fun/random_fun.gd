extends Node2D

var plane_path_scene: PackedScene = preload("uid://drmf6emnmt2pd")
@export var margin :int = 200
@export var min_travel :int = 300


@onready var terrain: TextureRect = %Background
@onready var waiting_marks: Node2D = %WaitingMarks

var plane_id :int = 0
var plane_count : int = 0
var waiting_path : Array[Vector2]

@onready var mouse = %Mouse
@onready var planes = %Planes

@onready var plane_pop_timer: Timer = %PlanePopTimer
@onready var game_over_timer: Timer = %GameOverTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()
	for mark in waiting_marks.get_children():
		waiting_path.append(mark.global_position)

func _bind_events():
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)
	EventBus.sigPlaneCrashed.connect(_on_plane_crashed)
	EventBus.sigNewPlaneTimer.connect(_on_new_plane_timer)

func _on_mouse_drag(mouse_pos: Vector2i):
	self.mouse.position = mouse_pos
	
func _on_mouse_button_clicked(mouse_pos: Vector2i):
	self.mouse.position = mouse_pos
		
func _on_mouse_button_released(_mouse: Vector2i):
	self.mouse.position = Vector2(-100, -100)

func get_map_color(mouse_pos:Vector2i):
	var color :Color = terrain.get_texture().get_image().get_pixel(mouse_pos.x, mouse_pos.y)
	return color
	
func get_target_pos(plane_pos : Vector2) -> Vector2:
	while true:
		var target_pos = Vector2(randi_range(margin, Global.WIDTH - margin), randi_range(margin, Global.HEIGHT - margin));
		if plane_pos.distance_to(target_pos) < min_travel:
			continue;
		var color = get_map_color(target_pos)
		if color.g > color.r and color.g > color.b:
			return target_pos
	return Vector2(0, 0)

func _on_new_plane_timer(wait: float):
	if not plane_pop_timer.is_stopped():
		plane_pop_timer.stop()
	plane_pop_timer.start(wait + randf())

func get_new_plane_type() -> int:
	# use plane_id
	if plane_id > 10:
		if randf() > 0.8:
			return 1
	if plane_id > 20:
		if randf() > 0.8:
			return 2
	if plane_id > 30:
		if randf() > 0.8:
			return 3
	
	return 0

func get_max_plane_count() -> int:
	# use plane_id
	var max_count = floori(1 + plane_id / 10.0)
	return max_count

func _on_plane_pop_timer_timeout():
	if plane_count > get_max_plane_count():
		EventBus.sigNewPlaneTimer.emit(1)
		return
		
	plane_id += 1
	plane_count += 1
	
	var plane_pos = Vector2(randi_range(margin, Global.WIDTH - margin), randi_range(margin, Global.HEIGHT - margin))
	var target_pos = get_target_pos(plane_pos)
	var plane_type = get_new_plane_type()
	
	var plane_path = plane_path_scene.instantiate()
	planes.add_child(plane_path)
	plane_path.init(plane_id, plane_type, plane_pos, target_pos, waiting_path)
	
	#EventBus.sigNewPlaneTimer.emit(randf_range(0.4, get_plane_pop_timer_value()))
	EventBus.sigNewPlaneTimer.emit(1)

func _on_plane_arrived(_id: int):
	EventBus.sigAddScore.emit(1)
	plane_count -= 1
	EventBus.sigNewPlaneTimer.emit(1)

func _on_plane_crashed(_id: int):
	game_over_timer.start(1.0)
	
func _on_game_over_timer_timeout() -> void:
	EventBus.sigGameOver.emit()
