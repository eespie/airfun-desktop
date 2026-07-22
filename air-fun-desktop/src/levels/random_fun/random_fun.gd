extends Node2D

var plane_path_scene: PackedScene = preload("uid://drmf6emnmt2pd")
@export var margin :int = 200
@export var min_travel :int = 300

@onready var waiting_markers : Array[Marker2D] = [
	%"Marker Top Right",
	%"Marker Top Left",
	%"Marker Bottom Left",
	%"Marker Bottom Right",
	%"Marker Top Right"
]

@onready var terrain: TextureRect = %Background

var plane_id :int = 0
var plane_count : int = 0
var waiting_path : Array[Vector2]

@onready var mouse = %Mouse
@onready var planes = %Planes

@onready var plane_pop_timer: Timer = %PlanePopTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()
	for i in waiting_markers.size():
		waiting_path.append(waiting_markers[i].global_position)

func _bind_events():
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)
	EventBus.sigPlaneCrashed.connect(_on_plane_crashed)
	EventBus.sigNewPlaneTimer.connect(_on_new_plane_timer)

func _on_mouse_drag(mouse: Vector2i):
	self.mouse.position = mouse
	
func _on_mouse_button_clicked(mouse: Vector2i):
	self.mouse.position = mouse
		
func _on_mouse_button_released(_mouse: Vector2i):
	self.mouse.position = Vector2(-100, -100)

func get_map_color(mouse:Vector2i):
	var color :Color = terrain.get_texture().get_image().get_pixel(mouse.x, mouse.y)
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
	if plane_pop_timer.is_stopped():
		plane_pop_timer.start(wait)

func get_new_plane_type() -> int:
	# use plane_count
	return randi_range(0, 3)

func _on_plane_pop_timer_timeout():
	if plane_count > 5:
		EventBus.sigNewPlaneTimer.emit(randf_range(0.1, 2.0))
		return
		
	plane_id += 1
	plane_count += 1
	
	var plane_pos = Vector2(randi_range(margin, Global.WIDTH - margin), randi_range(margin, Global.HEIGHT - margin))
	var target_pos = get_target_pos(plane_pos)
	var plane_type = get_new_plane_type()
	
	var plane_path = plane_path_scene.instantiate()
	planes.add_child(plane_path)
	plane_path.init(plane_id, plane_type, plane_pos, target_pos, waiting_path)
	
	EventBus.sigNewPlaneTimer.emit(randf_range(5, 10))

func _on_plane_arrived(_id: int):
	EventBus.sigAddScore.emit(1)
	plane_count -= 1
	EventBus.sigNewPlaneTimer.emit(randf_range(0.1, 2.0))

func _on_plane_crashed(_id: int):
	EventBus.sigGameOver.emit()
