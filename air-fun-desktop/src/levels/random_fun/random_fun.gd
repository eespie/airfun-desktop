extends Node2D

var plane_path_scene: PackedScene = preload("uid://drmf6emnmt2pd")
@export var margin :int = 200
@onready var waiting_markers : Array[Marker2D] = [
	%"Marker Top Right",
	%"Marker Top Left",
	%"Marker Bottom Left",
	%"Marker Bottom Right",
	%"Marker Top Right"
]
var terrain :TextureRect

var plane_id :int = 0
var plane_count : int = 0
var waiting_path : Array[Vector2]

@onready var mouse = %Mouse
@onready var planes = %Planes

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain = get_tree().get_first_node_in_group("terrain")
	for i in waiting_markers.size():
		waiting_path.append(waiting_markers[i].global_position)
	bind_events()

func bind_events():
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)

func _on_mouse_drag(mouse: Vector2i):
	self.mouse.position = mouse
	
func _on_mouse_button_clicked(mouse: Vector2i):
	self.mouse.position = mouse
		
	
func _on_mouse_button_released(_mouse: Vector2i):
	self.mouse.position = Vector2(-100, -100)

func get_color(mouse:Vector2i):
	var color :Color = terrain.get_texture().get_image().get_pixel(mouse.x, mouse.y)
	return color
	
func get_target_pos() -> Vector2:
	while true:
		var target_pos = Vector2(randi_range(margin, Global.WIDTH - margin), randi_range(margin, Global.HEIGHT - margin));
		var color = get_color(target_pos)
		if color.g > color.r and color.g > color.b:
			return target_pos
	return Vector2(0, 0)

func _on_plane_pop_timer_timeout():
	if plane_count > 5:
		return
		
	var plane_path = plane_path_scene.instantiate()
	plane_id += 1
	plane_count += 1
	plane_path.set_plane_id(plane_id)
	plane_path.waiting_path = waiting_path
	planes.add_child(plane_path)
	
	var target_pos = get_target_pos();
	plane_path.set_target_pos(target_pos)
	
	var plane_pos = Vector2(randi_range(margin, Global.WIDTH - margin), randi_range(margin, Global.HEIGHT - margin));
	plane_path.set_plane_pos(plane_pos)
	EventBus.sigTimerNext.emit(randi_range(5, 10))

func _on_plane_arrived(_id: int):
	EventBus.sigAddScore.emit(1)
	plane_count -= 1
	EventBus.sigTimerNext.emit(randf_range(0.1, 2.0))
