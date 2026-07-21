extends Node2D

@onready var path2D : Path2D = $Path2D
@onready var pathFollow2D :PathFollow2D = $Path2D/PathFollow2D
@onready var plane = $Path2D/PathFollow2D/PLane
@onready var plane_warning = $Path2D/PathFollow2D/PlaneWarning
@onready var curve: Curve2D
@onready var target = $Target
@onready var trajectory = $Trajectory
@onready var highlight_plane = %HighlightPlane
@onready var plane_image = %PlaneImage
@onready var plane_waiting_timer = %PlaneWaitingTimer

@export var waiting_radius :float = 50.0

var waiting_path : Array[Vector2]

var plane_colors : Array[Color] = [
	Color.CRIMSON,
	Color.BLUE,
	Color.GREEN,
	Color.DARK_SALMON,
	Color.BLUE_VIOLET,
	Color.WHITE_SMOKE,
	Color.VIOLET,
	Color.ORANGE,
	Color.YELLOW,
	Color.DEEP_PINK
]

var segment_length : float = 30
var screen_center = Vector2(Global.WIDTH/2, Global.HEIGHT/2)
var speed : float = 50
var progress : float = 0.0
# Progress on wait route
var last_wait_progress : float
var last_wait_time
var selected : bool = false
var current_rotation : float
# last point on curve
var last_point: Vector2
# last vector on curve
var last_vector: Vector2
var plane_id :int = 0
var plane_selected :int = 0

enum PlaneState {WAITING, END_WAITING, RUNNING, CRASHED}
var plane_state: PlaneState = PlaneState.WAITING

var plane_warned = []
var fuel :float = 60.0

var border_limit = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	plane_waiting_timer.start()
	_bind_events()

func _bind_events():
	EventBus.sigMouseDrag.connect(_on_mouse_drag)
	EventBus.sigMouseButtonReleased.connect(_on_mouse_button_released)
	EventBus.sigMouseButtonClicked.connect(_on_mouse_button_clicked)
	EventBus.sigPlaneSelect.connect(_on_plane_select)
	EventBus.sigPlaneArrived.connect(_on_plane_arrived)
	EventBus.sigPlaneCrashed.connect(_on_plane_crashed)
	EventBus.sigPlaneWarningStart.connect(_on_plane_warning_start)
	EventBus.sigPlaneWarningEnd.connect(_on_plane_warning_end)

func _process(delta):
	if plane_state == PlaneState.CRASHED:
		return
		
	if plane_state == PlaneState.WAITING:
		highlight_plane.show()
	else:
		highlight_plane.hide()
		
	var curve_len = curve.get_baked_length()
	if curve_len < 2:
		return
	progress += delta * speed
	while progress > curve_len:
		progress -= curve_len
	pathFollow2D.set_progress(progress)

	var current_transformation = curve.sample_baked_with_rotation(progress)
	current_rotation = current_transformation.get_rotation()
	var cur_pos = current_transformation.get_origin()
	
	# Check screen boundaries
	if cur_pos.x < border_limit or cur_pos.x > Global.WIDTH - border_limit or cur_pos.y < border_limit or cur_pos.y > Global.HEIGHT - border_limit:
		if plane_warned.find(plane_id) == -1:
			EventBus.sigPlaneWarningStart.emit(plane_id)
		if cur_pos.x < 0 or cur_pos.x > Global.WIDTH or cur_pos.y < 0 or cur_pos.y > Global.HEIGHT:
			if plane_state != PlaneState.CRASHED:
				EventBus.sigPlaneCrashed.emit(plane_id)
	elif plane_warned.find(plane_id) != -1:
		EventBus.sigPlaneWarningEnd.emit(plane_id)
	
	# Trajectory
	trajectory.clear_points()
	if plane_state == PlaneState.RUNNING:
		trajectory.show()
		var points = curve.get_baked_points()
		var curve_index: int = points.size() - 2
		var trajectory_progress = curve.get_closest_offset(points[curve_index])
		while trajectory_progress > progress:
			curve_index -= 1
			trajectory.add_point(points[curve_index])
			trajectory_progress = curve.get_closest_offset(points[curve_index])
	

func set_plane_id(id: int):
	plane_id = id
	
func set_target_pos(pos: Vector2):
	target.set_position(pos)
	#var plane_color = Color.from_hsv(randf_range(0.0, 1.0), randf_range(0.5, 1.0), randf_range(0.8, 1.0))
	var plane_color = plane_colors[plane_id % plane_colors.size()]
	target.modulate = plane_color
	plane_image.modulate = plane_color
	highlight_plane.self_modulate = Color.WHITE
	trajectory.modulate = plane_color
	propagate_call("set_plane_id", [plane_id])
	
func set_plane_pos(pos:Vector2):
	_build_waiting_circle()

func _build_waiting_circle():
	plane_state = PlaneState.WAITING

	# Reinint the curve
	curve = Curve2D.new()
	curve.clear_points()
	curve.bake_interval = segment_length
	path2D.set_curve(curve)
	
	# build a waiting path
	for i in waiting_path.size():
		curve.add_point(waiting_path[i])
	_smooth()
	progress = randf() * curve.get_baked_length()

	# Ignore collisions
	plane.monitorable = false
	plane.monitoring = false
	plane_warning.monitorable = false
	plane_warning.monitoring = false

func _smooth():
	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)

func _get_spline(i):
	var last_pt = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_pt.direction_to(next_point) * 10
	return spline

func _get_point(i):
	i = clampi(i, 0, curve.get_point_count() - 1)
	return curve.get_point_position(i)

func _select(is_selected: bool):
	selected = is_selected
	EventBus.sigPlaneSelect.emit(selected, plane_id)
	
func _on_plane_select(select :bool, id :int):
	if select:
		plane_selected = id
	else:
		plane_selected = 0

func _on_mouse_button_clicked(mouse: Vector2):
	if plane_selected != 0:
		return
	
	# save the progress on wait line
	last_wait_progress = progress
	last_wait_time = Time.get_ticks_usec()
	var current_position = curve.sample_baked(progress)

	if current_position.distance_to(mouse) > 32:
		return # click did not hit plane
	
	_select(true)
	# Allow collisions
	plane.monitorable = true
	plane.monitoring = true
	plane_warning.monitorable = true
	plane_warning.monitoring = true
	plane_state = PlaneState.RUNNING
	var plane_pos = current_position
	curve = Curve2D.new()
	curve.clear_points()
	curve.bake_interval = segment_length
	path2D.set_curve(curve)
	
	curve.add_point(plane_pos)
	last_point = mouse
	last_vector = plane_pos.direction_to(mouse)
	#curve.add_point(last_point)
	_smooth()
	pathFollow2D.set_loop(false)
	progress = 0.0


func _on_mouse_button_released(_mouse: Vector2):
	if not selected:
		return

	_select(false)
	_build_waiting_circle()
	var off_delta = (Time.get_ticks_usec() - last_wait_time) / 100000000.0
	progress = last_wait_progress + off_delta * speed
	
func _on_mouse_drag(mouse: Vector2):
	if not selected:
		return
		
	# Mouse arrive on target
	if target.position.distance_to(mouse) < 32:
		_select(false)
		curve.add_point(target.position)
		_smooth()
		plane_waiting_timer.stop()
		return
		
	if last_point.distance_to(mouse) < segment_length:
		return
		
	var current_vector = last_point.direction_to(mouse)
	curve.add_point(mouse)
	last_vector = current_vector
	last_point = mouse
	_smooth()


func _on_plane_arrived(id: int):
	if plane_id == id:
		queue_free()

func _on_plane_warning_start(id: int):
	plane_warned.append(id)

func _on_plane_warning_end(id: int):
	plane_warned.erase(id)
	
func _on_plane_crashed(id: int):
	if id == plane_id:
		plane_state = PlaneState.CRASHED

func _on_planeaiting_timer_timeout() -> void:
	if plane_state != PlaneState.WAITING:
		return
	# Allow collisions
	plane.monitorable = true
	plane.monitoring = true
	plane_warning.monitorable = true
	plane_warning.monitoring = true
	plane_state = PlaneState.END_WAITING
